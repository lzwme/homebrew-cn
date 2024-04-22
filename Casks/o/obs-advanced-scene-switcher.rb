cask "obs-advanced-scene-switcher" do
  version "1.25.5"
  sha256 "dadb46a7f9ed61bc3916f8a530dfbee5df57c40f3413b5d9f90b41cfe07befda"

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