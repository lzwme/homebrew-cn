cask "tiddly" do
  version "0.0.18"
  sha256 "7747ad4bbc2ff5f0cd0094a5ac4564879f97c24acb0e486b3c4d618bb7538da2"

  url "https:github.comJermoleneTiddlyDesktopreleasesdownloadv#{version}tiddlydesktop-mac64-v#{version}.zip"
  name "TiddlyWiki"
  desc "Browser for TiddlyWiki"
  homepage "https:github.comJermoleneTiddlyDesktop"

  app "TiddlyDesktop-mac64-v#{version}TiddlyDesktop.app"

  zap trash: [
    "~LibraryApplication SupportTiddlyDesktop",
    "~LibraryCachesTiddlyDesktop",
    "~LibraryPreferencescom.tiddlywiki.plist",
    "~LibrarySaved Application Statecom.tiddlywiki.savedState",
  ]
end