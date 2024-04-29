cask "stats" do
  on_mojave :or_older do
    version "2.8.26"
    sha256 "1a4b44ba02520683b0a6c192388f593c36dde4d15c784a22dccf0caefe81e8b7"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina :or_newer do
    version "2.10.11"
    sha256 "bc5df6b43b9201926b676d622ad33eff6aa4f565a8c8c75daed839c0adbe21a2"
  end

  url "https:github.comexelbanstatsreleasesdownloadv#{version}Stats.dmg"
  name "Stats"
  desc "System monitor for the menu bar"
  homepage "https:github.comexelbanstats"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Stats.app"

  uninstall quit: "eu.exelban.Stats"

  zap delete: "LibraryLaunchDaemonseu.exelban.Stats.SMC.Helper.plist",
      trash:  [
        "~LibraryApplication Scriptseu.exelban.Stats.LaunchAtLogin",
        "~LibraryCacheseu.exelban.Stats",
        "~LibraryContainerseu.exelban.Stats.LaunchAtLogin",
        "~LibraryCookieseu.exelban.Stats.binarycookies",
        "~LibraryHTTPStorageseu.exelban.Stats",
        "~LibraryPreferenceseu.exelban.Stats.plist",
      ]
end