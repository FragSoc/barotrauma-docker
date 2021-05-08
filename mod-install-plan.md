# Better Mod Installation Planning

Ideally, we want to pass an environment variable or file specifying desired mods to the container, and have it do all the rest.

Additionally, the system should not prevent people manually loading their own custom (or custom-versioned) mods.

1. Get desired modlist at runtime, use comma-separated env vars?
1. Use `steamcmd` to install mods.
  Potential caveats:
    - `steamcmd` requires interactive login, so doing this at container boot is pretty much impossible (thanks, valve)
    - `steamcmd` appears to download mods and name them according to their workshop ID, but the game seems to want them to be named with the mod names
1. Edit or generate the `.xml` file which points to mod paths.
    - Should be easily accomplished with `rash`'s support for templates

- Should have support for statically baking mods into the image and inserting them into the mods config alongside the runtime mods
  - If rash templating works this should be as easy as a separate env var that's ignored by the download script
- Should also support manually-added, non-workshop mods - another separate env var?
- Does `steamcmd` support updating mods in-place? If so, things are simplified a lot __so long as the mods folders aren't moved from what `steamcmd` expects__
- Volume for mods?
- Does the `player_config` file need the filepaths to match the mod name?

Given the above difficulties, if the ideal cannot be achieved, we could have a manually-invoked script to download files from the steam workshop, and have an ENV var to enable them at boot.
This has the additional advantage of letting people manage their files manually, and just selectively enabling them; perhaps this is preferable anyway?

## Suggested Env vars

- `MOD_WSIDS`
- `STATIC_MOD_WSIDS` - not for use at runtime
- `CUSTOM_MOD_PATHS` - use to marks paths which aren't uploaded to the workshop, intended for mod development/personal mods

## config_player.xml structure

```xml
<config
  language="English"
  masterserverurl="http://www.undertowgames.com/baromaster"
  autocheckupdates="true" >

  <!-- snip -->

  <contentpackages>
    <core
      name="Vanilla 0.9" />
    <regular>
      <!-- Mod entries go here -->
      <package name="Ulysses" enabled="true"/>
    </regular>

  </contentpackages>

  <!-- snip -->

</config>
```
