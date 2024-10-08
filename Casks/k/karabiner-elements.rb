cask "karabiner-elements" do
  on_mojave :or_older do
    on_el_capitan :or_older do
      version "11.6.0"
      sha256 "c1b06252ecc42cdd8051eb3d606050ee47b04532629293245ffdfa01bbc2430d"
    end
    on_sierra :or_newer do
      version "12.10.0"
      sha256 "53252f7d07e44f04972afea2a16ac595552c28715aa65ff4a481a1c18c8be2f4"
    end

    livecheck do
      skip "Legacy version"
    end

    pkg "Karabiner-Elements.sparkle_guided.pkg"

    uninstall launchctl: [
                "org.pqrs.karabiner.agent.karabiner_grabber",
                "org.pqrs.karabiner.agent.karabiner_observer",
                "org.pqrs.karabiner.karabiner_console_user_server",
                "org.pqrs.karabiner.karabiner_kextd",
                "org.pqrs.karabiner.karabiner_session_monitor",
              ],
              signal:    [
                ["TERM", "org.pqrs.Karabiner-Menu"],
                ["TERM", "org.pqrs.Karabiner-NotificationWindow"],
              ],
              script:    {
                executable: "LibraryApplication Supportorg.pqrsKarabiner-Elementsuninstall_core.sh",
                sudo:       true,
              },
              pkgutil:   "org.pqrs.Karabiner-Elements",
              delete:    "LibraryApplication Supportorg.pqrs"
  end
  on_catalina :or_newer do
    on_catalina do
      version "13.7.0"
      sha256 "9ac5e53a71f3a00d7bdb2f5f5f001f70b6b8b7b2680e10a929e0e4c488c8734b"

      livecheck do
        skip "Legacy version"
      end
    end
    on_big_sur do
      version "14.13.0"
      sha256 "826270a21b7f4df9b9a8c79c9aad4de8f48021f58eaacbee1d4f150c963c6cbc"

      livecheck do
        skip "Legacy version"
      end
    end
    on_monterey do
      version "14.13.0"
      sha256 "826270a21b7f4df9b9a8c79c9aad4de8f48021f58eaacbee1d4f150c963c6cbc"

      livecheck do
        skip "Legacy version"
      end
    end
    on_ventura :or_newer do
      version "15.2.0"
      sha256 "7e56ee5615b442c51f47da4818c4275c504f1d4536b73f0f3d0329429b54dad8"

      livecheck do
        url "https:appcast.pqrs.orgkarabiner-elements-appcast.xml"
        strategy :sparkle
      end
    end

    pkg "Karabiner-Elements.pkg"

    uninstall early_script: {
                executable: "LibraryApplication Supportorg.pqrsKarabiner-DriverKit-VirtualHIDDevicescriptsuninstallremove_files.sh",
                sudo:       true,
              },
              launchctl:    [
                "org.pqrs.karabiner.agent.karabiner_grabber",
                "org.pqrs.karabiner.agent.karabiner_observer",
                "org.pqrs.karabiner.karabiner_console_user_server",
                "org.pqrs.karabiner.karabiner_grabber",
                "org.pqrs.karabiner.karabiner_observer",
                "org.pqrs.karabiner.karabiner_session_monitor",
                "org.pqrs.karabiner.NotificationWindow",
              ],
              signal:       [
                ["TERM", "org.pqrs.Karabiner-Menu"],
                ["TERM", "org.pqrs.Karabiner-NotificationWindow"],
              ],
              script:       {
                executable: "LibraryApplication Supportorg.pqrsKarabiner-Elementsuninstall_core.sh",
                sudo:       true,
              },
              pkgutil:      [
                "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice",
                "org.pqrs.Karabiner-Elements",
              ],
              delete:       "LibraryApplication Supportorg.pqrs"
    # The system extension 'org.pqrs.Karabiner-DriverKit-VirtualHIDDevice*' should not be uninstalled by Cask
  end

  url "https:github.compqrs-orgKarabiner-Elementsreleasesdownloadv#{version}Karabiner-Elements-#{version}.dmg",
      verified: "github.compqrs-orgKarabiner-Elements"
  name "Karabiner Elements"
  desc "Keyboard customiser"
  homepage "https:karabiner-elements.pqrs.org"

  auto_updates true

  binary "LibraryApplication Supportorg.pqrsKarabiner-Elementsbinkarabiner_cli"

  zap trash: [
    "~.configkarabiner",
    "~.localsharekarabiner",
    "~LibraryApplication Scriptsorg.pqrs.Karabiner-VirtualHIDDevice-Manager",
    "~LibraryApplication SupportKarabiner-Elements",
    "~LibraryCachesorg.pqrs.Karabiner-Elements.Updater",
    "~LibraryContainersorg.pqrs.Karabiner-VirtualHIDDevice-Manager",
    "~LibraryHTTPStoragesorg.pqrs.Karabiner-Elements.Settings",
    "~LibraryPreferencesorg.pqrs.Karabiner-Elements.Updater.plist",
  ]
end