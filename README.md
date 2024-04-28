# Overview
This addon dynamically changes PlayerNames inside user defined macros to character name they would want to change it manually before entering arenas. To make this work I enhanced blizzard macro language and it has a little different syntax as default macros which will be explained later in documentation.

Addon **will be loaded** whenever number of players in party is **2** or **3** and you are in **arena**. In every other scenario addon will do **nothing** unless you are triggering it for testing purposes outside of arena instance (more on that down below in **usage** section.
Addon is developed for **PvP only** and therefore PvE requests to enhance addon will be most likely ignored.

This addon is **developed for DPS classes** because Healers are using @party1/2 targetting macros and this would be worthless for them.

**SoloQueue is fully supported** and therefore in case protection paladins have been present in soloQ they will be considered as healers in DynamicMacros addon. Other tanks than protection paladins will be considered as damagers in DynamicMacros addon.

Addon **will not work** in 3v3 arenas where team compositions are: (Healer + prot paladin + anything)

*Just stop playing tank in PvP nobody wants **you**.*
___
### DynamicMacros usage:

**To manually trigger addon in any instance where your group size is 2 or 3 simply type /dmt**

This is extremely handy feature for you when you are creating macros first time and you want to see whether it worked as you expected. On top of that this command can be used if addon bugs out for some reason and your macros are not updated as they are supposed to (for example in middle of solo shuffle rounds)

**To open addon settings type in chat /dm**

Settings window will be opened which is pretty simple to use. Here you will specify macro names which you want to behave as DynamicMacros. Bottom window will show you list of macro names which you already defined to behave as DynamicMacros. Once your macro name appears in this window we can proceed to macro syntax and create one.
**Warning: Do not create macros with the same names. Then it will do nothing.**

#### DynamicMacro Syntax

I ll show here **4 examples** how this logic work what should help you create your own macros. 
In those examples you will see word **"dynamicMacros"**. It is just for clear presentation how it works. On creation of macro you can write there instead of **"dynamicMacros"** anything (table,mouse,dog,cat, simply whatever comes to your mind.) This string will be anyway replaced with playername once you are in party with 2 or 3 members. This is just for initial setup.

Keep in mind those are just 4 examples from basic to advanced macros. 

First line with @dynamicMacros (excluding facts below) will be considered as strings for healer. 
Second line of @dynamicMacros(excluding facts below) will be considered as line for dps and each occurence of @dynamicMacros will be replaced with damager. 

**Facts:** 
@target, @focus, mouseover, @partypet1, @partypet2, @arena1, @arena2, @arena3, @player, @cursor, @yourcharactername wont be touched and will behave as blizzard intended to.

Modifiers(nomod,shift..) which I use in examples are totally optional. They work same way they do in default macros by Blizzard.

1. **cast on friendly healer without modifier and on friendly dps in team with shift modifier**

    *#showtooltip Regrowth*   
    */cast [nomod,@dynamicMacros] Regrowth*   
    */cast [mod:shift,@dynamicMacros] Regrowth*
   
    Lets say you are in soloQ. Second line would automatically replace "dynamicMacros" with name of you healer in team. Same logic will be applied for dps and second word "dynamicMacros" at third line would be replaced with name of damager in team.
    That way you didnt have to touch your macros and they would still work.

2. **cast spell on friendly DPS in any situation 2v2/3v3/soloQ**
   
   *#showtooltip Void Shift*\
   */cast [nomod,@dynamicMacros]*   
   */cast [@dynamicMacros] Void Shift*
   
    Even tho nobody wants to cast anything on "healer" (maybe he is not even present in your team) second line has to be written inside macro without specifying spell which should be cast on healer to make it work. Third line will be considered as line for damager.

3. **cast spell on friendly healer in any situation 2v2/3v3/soloQ**
   
    *#showtooltip Void Shift*   
    */cast [@dynamicMacros] Void Shift*
   
    To cast on healer it is sufficient to specify just one line as you can see above unlike for dps.

4. **nomodifier cast on me (krionel is my character name), shift modifier cast on healer and if he does not exists cast on target, ctrl modifier cast on damager and if he does not exists cast on focus**
   
    *#showtooltip*   
    */cast [nomod,@Krionel]Regrowth*   
    */cast [mod:shift,@dynamicMacros,exists][mod:shift,@target]Regrowth*   
    */cast [mod:ctrl,@dynamicMacros,exists][mod:ctrl,@focus]Regrowth*
   
___
### Useful information
Macros wont be updating while you have default blizzard macro window GUI opened. So simply once you create macro close this window to make it work. Then you can reopen it once you are in 2 or 3 membered party to see changes.

Keep in mind addon updates your macros 3 seconds after your party group is updated and you are inside 2v2 or 3v3 arena. This means somebody leaves/joins/wentOffline/wentOnline/loadIntoArena and at the same time number of player in group is still 2 or 3.

This is the logic how it works. This way your macros dynamically assign name of player you would overwrite manually and you never have to do that again.

Ctrl modifier for **friendly players is bugged** since launch of Dragonflight. It is actually **not an issue of addon but game itself**. Ctrl does not work in normal macros too. Workaround for that is to bind ctrl+letter directly into action bars and create macro without specified ctrl modifier in it.

### More random examples (some people still do not understand it)

1. **cast on friendly healer without any modifier at all**

    *#showtooltip Blessing of Protection*   
    */cast [@dynamicMacros] Blessing of Protection*   

2. **cast spell on friendly DPS (NOT healer at all) without any modifer**
   
   *#showtooltip Leap of Faith*\
   */cast [@dynamicMacros]*   
   */cast [@dynamicMacros] Leap of Faith*

3. **cast spell on healer based on known talent (Blessing of Sanctuary/ Blessing of Spellwarding) 

   *#showtooltip*   
   */cast [known:Blessing of sanctuary, @dynamicMacros] Blessing of sanctuary; [@dynamicMacros] Blessing of spellwarding;*
   
4. **cast spell on damager based on known talent (Blessing of Sanctuary/ Blessing of Spellwarding)**

   *#showtooltip*   
   */cast [nomod,@dynamicMacros]*
   
   */cast [known:Blessing of sanctuary, @dynamicMacros] Blessing of sanctuary; [@dynamicMacros] Blessing of spellwarding;*

---
### ** Valuable Testers**
##### **Marimvp** *(helped to find root cause of pesky bug when sometimes macros are not updated between solo shuffle rounds)*
---
**Credit for idea goes to Black**

