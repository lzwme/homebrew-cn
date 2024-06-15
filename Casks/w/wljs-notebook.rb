cask "wljs-notebook" do
  arch arm: "-arm64"

  version "2.4.2"
  sha256 arm:   "42f981b906cc317928e1c8020e219e2525841db9c857504d5406ce4000cc1f62",
         intel: "b636380ac88194e3365f07d549b016a1cacb903bfcdf805244884a377e539bf2"

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