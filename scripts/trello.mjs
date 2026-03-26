#!/usr/bin/env node
/**
 * trello.mjs — Lightweight Trello CLI for OpenClaw agents
 * 
 * Usage:
 *   trello.mjs boards                          # List boards
 *   trello.mjs lists <boardId>                  # List lists on a board
 *   trello.mjs cards <listId>                   # List cards in a list
 *   trello.mjs card <cardId>                    # Get card details
 *   trello.mjs create <listId> "title" ["desc"] # Create a card
 *   trello.mjs move <cardId> <listId>           # Move card to list
 *   trello.mjs comment <cardId> "text"          # Add comment to card
 *   trello.mjs label <cardId> <color>           # Add label (green/yellow/orange/red/purple/blue)
 *   trello.mjs checklist <cardId> "name" "item1,item2,item3"  # Add checklist
 *   trello.mjs check <cardId> <checkItemId>     # Mark checklist item done
 *   trello.mjs assign <cardId> <memberId>       # Assign member
 *   trello.mjs members <boardId>                # List board members
 *   trello.mjs search "query"                   # Search cards
 *   trello.mjs setup <boardName>                # Create a new board with standard lists
 * 
 * Env: TRELLO_API_KEY, TRELLO_TOKEN
 */

const API = 'https://api.trello.com/1';
const KEY = process.env.TRELLO_API_KEY;
const TOKEN = process.env.TRELLO_TOKEN;

if (!KEY || !TOKEN) {
  console.error('Error: Set TRELLO_API_KEY and TRELLO_TOKEN env variables');
  process.exit(1);
}

const auth = `key=${KEY}&token=${TOKEN}`;

async function api(path, method = 'GET', body = null) {
  const sep = path.includes('?') ? '&' : '?';
  const url = `${API}${path}${sep}${auth}`;
  const opts = { method, headers: { 'Content-Type': 'application/json' } };
  if (body) opts.body = JSON.stringify(body);
  const res = await fetch(url, opts);
  if (!res.ok) {
    const err = await res.text();
    console.error(`API error (${res.status}): ${err}`);
    process.exit(1);
  }
  return res.json();
}

const [cmd, ...args] = process.argv.slice(2);

async function main() {
  switch (cmd) {
    case 'boards': {
      const boards = await api('/members/me/boards?fields=name,url,closed');
      boards.filter(b => !b.closed).forEach(b => 
        console.log(`${b.id}  ${b.name.padEnd(35)} ${b.url}`)
      );
      break;
    }
    
    case 'lists': {
      const [boardId] = args;
      if (!boardId) { console.error('Usage: lists <boardId>'); process.exit(1); }
      const lists = await api(`/boards/${boardId}/lists?fields=name,pos`);
      lists.forEach(l => console.log(`${l.id}  ${l.name}`));
      break;
    }
    
    case 'cards': {
      const [listId] = args;
      if (!listId) { console.error('Usage: cards <listId>'); process.exit(1); }
      const cards = await api(`/lists/${listId}/cards?fields=name,desc,labels,due,idMembers,shortUrl`);
      cards.forEach(c => {
        const labels = c.labels.map(l => l.color).join(',');
        console.log(`${c.id}  ${labels ? `[${labels}]` : ''} ${c.name}  ${c.shortUrl}`);
      });
      break;
    }
    
    case 'card': {
      const [cardId] = args;
      if (!cardId) { console.error('Usage: card <cardId>'); process.exit(1); }
      const c = await api(`/cards/${cardId}?fields=name,desc,labels,due,idMembers,idList,shortUrl&checklists=all&actions=commentCard&actions_limit=10`);
      console.log(JSON.stringify(c, null, 2));
      break;
    }
    
    case 'create': {
      const [listId, name, desc] = args;
      if (!listId || !name) { console.error('Usage: create <listId> "title" ["desc"]'); process.exit(1); }
      const card = await api('/cards', 'POST', { idList: listId, name, desc: desc || '', pos: 'bottom' });
      console.log(`✅ Created: ${card.name} (${card.id})`);
      console.log(`   ${card.shortUrl}`);
      break;
    }
    
    case 'move': {
      const [cardId, listId] = args;
      if (!cardId || !listId) { console.error('Usage: move <cardId> <listId>'); process.exit(1); }
      const card = await api(`/cards/${cardId}`, 'PUT', { idList: listId });
      console.log(`✅ Moved "${card.name}" to list`);
      break;
    }
    
    case 'comment': {
      const [cardId, ...textParts] = args;
      const text = textParts.join(' ');
      if (!cardId || !text) { console.error('Usage: comment <cardId> "text"'); process.exit(1); }
      await api(`/cards/${cardId}/actions/comments`, 'POST', { text });
      console.log(`✅ Comment added`);
      break;
    }
    
    case 'label': {
      const [cardId, color] = args;
      if (!cardId || !color) { console.error('Usage: label <cardId> <color>'); process.exit(1); }
      // Get board labels first
      const card = await api(`/cards/${cardId}?fields=idBoard`);
      const labels = await api(`/boards/${card.idBoard}/labels`);
      const label = labels.find(l => l.color === color);
      if (label) {
        await api(`/cards/${cardId}/idLabels`, 'POST', { value: label.id });
        console.log(`✅ Label ${color} added`);
      } else {
        console.error(`No ${color} label found on board`);
      }
      break;
    }
    
    case 'checklist': {
      const [cardId, name, items] = args;
      if (!cardId || !name) { console.error('Usage: checklist <cardId> "name" "item1,item2"'); process.exit(1); }
      const cl = await api(`/cards/${cardId}/checklists`, 'POST', { name });
      if (items) {
        for (const item of items.split(',')) {
          await api(`/checklists/${cl.id}/checkItems`, 'POST', { name: item.trim() });
        }
      }
      console.log(`✅ Checklist "${name}" added with ${items ? items.split(',').length : 0} items`);
      break;
    }
    
    case 'check': {
      const [cardId, checkItemId] = args;
      if (!cardId || !checkItemId) { console.error('Usage: check <cardId> <checkItemId>'); process.exit(1); }
      await api(`/cards/${cardId}/checkItem/${checkItemId}`, 'PUT', { state: 'complete' });
      console.log(`✅ Item checked`);
      break;
    }
    
    case 'assign': {
      const [cardId, memberId] = args;
      if (!cardId || !memberId) { console.error('Usage: assign <cardId> <memberId>'); process.exit(1); }
      await api(`/cards/${cardId}/idMembers`, 'POST', { value: memberId });
      console.log(`✅ Member assigned`);
      break;
    }
    
    case 'members': {
      const [boardId] = args;
      if (!boardId) { console.error('Usage: members <boardId>'); process.exit(1); }
      const members = await api(`/boards/${boardId}/members?fields=fullName,username`);
      members.forEach(m => console.log(`${m.id}  ${m.fullName} (@${m.username})`));
      break;
    }
    
    case 'search': {
      const query = args.join(' ');
      if (!query) { console.error('Usage: search "query"'); process.exit(1); }
      const results = await api(`/search?query=${encodeURIComponent(query)}&modelTypes=cards&cards_limit=20`);
      results.cards.forEach(c => console.log(`${c.id}  ${c.name}  ${c.shortUrl}`));
      break;
    }
    
    case 'setup': {
      const [boardName] = args;
      if (!boardName) { console.error('Usage: setup "Board Name"'); process.exit(1); }
      const board = await api('/boards', 'POST', { 
        name: boardName, 
        defaultLists: false,
        prefs_permissionLevel: 'private'
      });
      console.log(`✅ Board created: ${board.url}`);
      
      // Create standard lists in order
      const lists = ['📋 Backlog', '🔍 Analysis', '🚧 In Progress', '👀 Review', '✅ Done'];
      for (let i = lists.length - 1; i >= 0; i--) {
        const l = await api('/lists', 'POST', { name: lists[i], idBoard: board.id, pos: 'top' });
        console.log(`   ${l.id}  ${lists[i]}`);
      }
      console.log(`\nBoard ID: ${board.id}`);
      break;
    }
    
    default:
      console.error(`Unknown command: ${cmd}`);
      console.error('Commands: boards, lists, cards, card, create, move, comment, label, checklist, check, assign, members, search, setup');
      process.exit(1);
  }
}

main().catch(e => { console.error('Error:', e.message); process.exit(1); });
