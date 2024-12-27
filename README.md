# Pappu PlayerList
Pappu PlayerList is a customizable and lightweight player list for FiveM servers.


## Features
- New: Ability Discord webhook in server/main.lua - 4 Line
- Maximum Players: Automatically fetches the maximum players from server settings (sv_maxclients).
- Identifiers: Display different identifiers like citizenid, steam, or license.
- Character Name Display: Show character names instead of identifiers.
- ID Above Head: Enable or disable player ID display above heads.
- Disable Controls: Disable other controls when the scoreboard is open to prevent unintended actions.
- Emote Playback: Option to play emotes when the scoreboard is open.
- Custom Animation: Use your preferred animation dictionary and emote.


## Preview
![Group 1000004223](https://github.com/user-attachments/assets/fdcda3a3-5b5a-49e8-917e-77d5139108b1)



## Installation

1. **Download and Extract**
   - Download the Pappu PlayerList resource.
   - Extract the files to your FiveM resource folder (e.g., `resources/[your-folder]/pappu-playerlist`).

2. **Add to `server.cfg`**
   - Add the following line to your `server.cfg`:
     ```cfg
     ensure pappu-playerlist
     ```

3. **Configure**
   - Open the `nui/config.json` file and customize the settings according to your server's needs.

4. **Test and Debug**
   - Start the server and press the key bound to `Config.OpenKey` (default: `U`) to ensure the player list works correctly.

---

## Future Enhancements
- **Framework Compatibility**: Enhanced support for more core frameworks.
- **Dynamic UI Themes**: Allow server owners to apply custom themes.
- **Advanced Debug Tools**: Additional debugging features to simplify troubleshooting.
- **Localization**: Support for multiple languages.

---

## Support
If you encounter any issues or have feature requests, feel free to open an issue on the GitHub repository or contact us via [Discord](https://discord.com/invite/uEuetEY3jd).

---

## License
[GPL-3.0 license](LICENSE)
