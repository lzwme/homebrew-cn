cask "wljs-notebook" do
  arch arm: "-arm64"

  version "2.2.9"
  sha256 arm:   "2b1152aa715b9be885522c63c5ba60744ec3317ea8d5377354b7f869043d6f37",
         intel: "a93c1aad237357298662f87d27caa4d55f9b2decc04fe4fa9007fdb15bcebcf6"

  url "https:github.comJerryIwolfram-js-frontendreleasesdownload#{version}WLJS.Notebook-#{version}#{arch}.dmg"
  name "WLJS Notebook"
  desc "Javascript frontend for Wolfram Engine"
  homepage "https:github.comJerryIwolfram-js-frontend"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "WLJS Notebook.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentswljs-notebook.sfl*",
    "~LibraryApplication Supportwljs-notebook",
    "~LibraryPreferenceswljs-notebook.plist",
    "~LibrarySaved Application Statewljs-notebook.savedState",
  ]
end