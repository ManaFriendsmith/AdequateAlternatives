# ABOUT

This is a factorio mod that (mostly) ports the alternate recipe mechanic from Satisfactory.

While factorio is the far superior game at the micro-level (two-lane belts, inserters, and the ability to insert or remove from any spot on a machine result in a far richer system than Satisfactory's braindead A-to-B belts, no enforcement of clipping, and cumbersome first-person building), vanilla factorio suffers from a lack of any kind of large-scale decisionmaking with ongoing ramifications. You are always going to have to automate every item, and you are always going to automate that recipe the same way; the only real question is where to set up each facility. In Space Age there is sometimes a question of which planet to build a particular thing on, but the cost of moving items between planets means you need a little of everything non-planet-specific produced locally anyway.

Mods do often add alternate recipes for things but they're oftentimes just a strict upgrade, and also integrated into the normal tech tree; unlocking them either happens anyway in the course of progression, or has no trade-off to unlocking them other than the cost of science packs.

This mod adds an alternative tech tree that starts completely hidden. Alien biological samples can be obtained from biter nests, egg rafts, demolisher corpses, and Fulgoran gene vaults, and used to create special science packs. Spawners formed as part of expansions do not drop anything. These can be used to research repeatable technologies with an escalating cost that reveal 1-2 new techs from the alternative researches, and grants 1 tech point. A custom GUI allows spending 1 tech point to unlock 1 technology. It is deliberate that these are unlocked by things that are not directly automatable/scalable. In the course of a normal game you will probably not unlock everything and will have to strategically pick which recipes of the subset you are offered are the most situationally useful, resulting in more variety and replayability.

When revealing new technologies, the game will try to prioritize things that players can currently make based on their current research progress. If all possible alternative techs are already revealed, techs will be revealed purely at random. There is also a bias based on how you reveal them; for instance, researching demolisher remains is more likely to unlock metallurgical technologies or uses for tungsten.

While the intention is to provide almost exclusively alternate recipes, each alternate is implemented as a technology prototype so that a) the system is expandable by other mods, and b) they can theoretically add any type of bonus that normal technologies can. Even within the realm of just providing alternate recipes for existing items there is a lot of potential to shake up the game. While a lot of the recipes are things like "make this thing out of steel instead of iron" you can also get things like:

- unlock efficiency modules early, slightly more expensive but craftable without oil
- convert cars to trains and concrete to rails
- turn yumako and jelly directly into finished products that have to be recycled

# DEPENDENCIES

- [pf-functions](https://github.com/ManaFriendsmith/pf-functions) - Library and some misc functionality that does not belong to any one content mod

# RELATED

- More Materials series: my other mods add a bunch of extra intermediates which make the possibilites for alternate recipes explode. (these alternate recipes are not currently implemented, but planned as an immediate goal once vanilla is decent, and if i don't promise it i will forget)
- [Brass Tacks](https://github.com/ManaFriendsmith/BrassTacksMk2) - Adds zinc and brass. Mechanical parts and galvanized items. Heavily affects Vulcanus, Fulgora.
- [If I Had A Nickel](https://github.com/ManaFriendsmith/IfNickelMk2) - Adds nickel and invar. Motors, valves, rocket engines. Heavily affects Vulcanus, Gleba.
- [Them Thar Hills](https://github.com/ManaFriendsmith/ThemTharHillsMk2) - Adds gold. Electronic components. Heavily affects all inner planets.
- [BrimStuff](https://github.com/ManaFriendsmith/BrimStuffMk2) - Reworks sulfur and chemistry. Rubber, explosives, waste processing. Heavily affects all planets + space platforms.
- [LasingAround](https://github.com/ManaFriendsmith/LasingAroundMk2) - Adds helium. Lasers and advanced crafting machines. Heavily affects Nauvis, Fulgora, Aquilo.

# KNOWN ISSUES

- The code is very badly organized because I was trying to see whether I could implement this at all.
- The GUI is not nice. This is my first ever attempt at a modded gui so go easy on me.
- The GUI does not support displaying every type of technology bonus. This is a matter of me being too lazy to reimplement them all. I'm not sure if I want to do that since I might just tear the GUI down at some point and start over.

# CREDITS

- Planetfall - Code, graphics
