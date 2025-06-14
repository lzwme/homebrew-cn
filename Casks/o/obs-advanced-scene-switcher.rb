cask "obs-advanced-scene-switcher" do
  version "1.30.2"
  sha256 "985587d8f7a17e8a43c8dad03b8683bbc90db6d30d7323ea12457e1e7fb7278a"

  url "https:github.comWarmUpTillSceneSwitcherreleasesdownload#{version}advanced-scene-switcher-#{version}-macos-universal.pkg",
      verified: "github.comWarmUpTillSceneSwitcher"
  name "OBS Advanced Scene Switcher"
  desc "Automated scene switcher for OBS Studio"
  homepage "https:obsproject.comforumresourcesadvanced-scene-switcher.395"

  livecheck do
    url :url
    strategy :github_latest
  end

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