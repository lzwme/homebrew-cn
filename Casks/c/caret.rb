cask "caret" do
  version "3.4.6"
  sha256 "a7d17bb7e9c938d8559f1569899a14413dae33bc4a7d4de038bf430447008aea"

  url "https:github.comcareteditorissuesreleasesdownload#{version}Caret.dmg",
      verified: "github.comcareteditorissues"
  name "Caret"
  homepage "https:caret.io"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Caret.app"

  zap trash: [
    "~LibraryApplication SupportCaret",
    "~LibraryCachesio.caret",
    "~LibraryCachesio.caret.ShipIt",
    "~LibraryCookiesio.caret.binarycookies",
    "~LibraryPreferencesio.caret.helper.plist",
    "~LibraryPreferencesio.caret.plist",
    "~LibrarySaved Application Stateio.caret.savedState",
  ]
end