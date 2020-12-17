-- ModFreakz
-- For support, previews and showcases, head to https://discord.gg/ukgQa5K

Requirements
- HHCore
- hhrp_inventoryhud
- MF_SafeCracker

Installation

- Extract into resources folder.
- Start in server cfg.
- Make sure all dependencies are installed.
- If SQL file provided, use it.
- Check config for options you may need to change.
- Copy the property.lua from our mod folder. Paste into hhrp_inventoryhud/client and replace the existing file.
- Head into "hhrp_inventoryhud/client/main.lua" and find the "closeInventory" function

- Add this line below "SetNuiFocus(false,false)"
  TriggerEvent('hhrp_inventoryhud:closeInventory')
  
- Add this event below the "closeInventory" function
  RegisterNetEvent('hhrp_inventoryhud:doClose')
  AddEventHandler('hhrp_inventoryhud:doClose', function(...) closeInventory(...); end)

- Make sure all dependencies are installed.
- Make sure you're added on the webhook. If you have no idea what this is, join at the discord link above and post a ticket.

Usage
- /giveitem YOURID playersafe
- Use the safe (from inventory)
- Enjoy