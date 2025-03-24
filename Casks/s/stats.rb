cask "stats" do
  on_mojave :or_older do
    version "2.8.26"
    sha256 "1a4b44ba02520683b0a6c192388f593c36dde4d15c784a22dccf0caefe81e8b7"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina :or_newer do
    version "2.11.36"
    sha256 "112099596270ce4b9cfb9d6a48e563eb7e670037f3da51d1b1f9fa610c81ebd5"
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
        "~LibraryApplication Scriptseu.exelban.Stats.Widgets",
        "~LibraryCacheseu.exelban.Stats",
        "~LibraryContainerseu.exelban.Stats.LaunchAtLogin",
        "~LibraryContainerseu.exelban.Stats.Widgets",
        "~LibraryCookieseu.exelban.Stats.binarycookies",
        "~LibraryGroup Containerseu.exelban.Stats.widgets",
        "~LibraryHTTPStorageseu.exelban.Stats",
        "~LibraryPreferenceseu.exelban.Stats.plist",
      ]
end