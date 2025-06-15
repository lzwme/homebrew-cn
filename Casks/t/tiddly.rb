cask "tiddly" do
  arch arm: "applesilicon", intel: "64"

  version "0.0.20"
  sha256 arm:   "4346518579399ade0b16429860a1fef92940a621c2444094ded21d926d353bb7",
         intel: "d41af9408f0a3f160c486e568883ac55c7388274f63c6ec3117db616de3f1c0c"

  url "https:github.comJermoleneTiddlyDesktopreleasesdownloadv#{version}tiddlydesktop-mac#{arch}-v#{version}.zip"
  name "TiddlyWiki"
  desc "Browser for TiddlyWiki"
  homepage "https:github.comJermoleneTiddlyDesktop"

  no_autobump! because: :requires_manual_review

  app "TiddlyDesktop-mac#{arch}-v#{version}TiddlyDesktop.app"

  zap trash: [
    "~LibraryApplication SupportTiddlyDesktop",
    "~LibraryCachesTiddlyDesktop",
    "~LibraryPreferencescom.tiddlywiki.plist",
    "~LibrarySaved Application Statecom.tiddlywiki.savedState",
  ]
end