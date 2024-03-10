cask "obs-advanced-scene-switcher" do
  version "1.25.3"
  sha256 "f7f11721ac59c148bcbce8811e0e1a72e1363a0efdde242879a1df2423a132d0"

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