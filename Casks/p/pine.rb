cask "pine" do
  version "0.1.0"
  sha256 "046f2603f7e4dcdc7535c6a5652dbfbab5cbe93fa36ca161f8a8029b53770b76"

  url "https:github.comlukakerrpinereleasesdownload#{version}Pine-#{version}.zip"
  name "Pine"
  desc "Native markdown editor"
  homepage "https:github.comlukakerrpine"

  depends_on macos: ">= :sierra"

  app "Pine.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.github.lukakerr.pine.sfl*",
    "~LibraryApplication SupportPine",
    "~LibraryCachesio.github.lukakerr.Pine",
    "~LibraryPreferencesio.github.lukakerr.Pine.plist",
    "~LibrarySaved Application Stateio.github.lukakerr.Pine.savedState",
    "~LibraryWebKitio.github.lukakerr.Pine",
  ]
end