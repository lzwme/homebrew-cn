cask "wljs-notebook" do
  arch arm: "-arm64"

  version "2.3.5"
  sha256 arm:   "05236a9d22f5bb4adac28461dd01f22ecc807055ab22866a831b681ddbf0338d",
         intel: "6ef01ab8a638e419c43abe32e50aed8c5ce6786b6d18a64bff8daf4021694623"

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