cask "obs-advanced-scene-switcher" do
  version "1.28.0"
  sha256 "52060f93ea36040319928eb1871f03959ab18af07ff23ab8491ad3fb954b44d4"

  url "https:github.comWarmUpTillSceneSwitcherreleasesdownload#{version}advanced-scene-switcher-#{version}-macos-universal.pkg",
      verified: "github.comWarmUpTillSceneSwitcher"
  name "OBS Advanced Scene Switcher"
  desc "Automated scene switcher for OBS Studio"
  homepage "https:obsproject.comforumresourcesadvanced-scene-switcher.395"

  depends_on cask: "obs"

  pkg "advanced-scene-switcher-#{version}-macos-universal.pkg"

  uninstall pkgutil: [
              "'com.warmuptill.advanced-scene-switcher'",
              "com.warmuptill.advanced-scene-switcher",
            ],
            delete:  "LibraryApplication Supportobs-studiopluginsadvanced-scene-switcher.plugin",
            rmdir:   "LibraryApplication Supportobs-studioplugins"

  # No zap stanza required
end