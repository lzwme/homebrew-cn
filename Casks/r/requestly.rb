cask "requestly" do
  arch arm: "-arm64"

  version "1.6.0"
  sha256 arm:   "5e17a3256ad4adb1a45bdd7f283b5aedc982b3aa01a053e4ec10a5e13c8a5172",
         intel: "f09e5b41b5b585c35fe93ba53f83b3b4257589ad2b44d6e7c3428cc16a9ee71d"

  url "https:github.comrequestlyrequestly-desktop-appreleasesdownloadv#{version}Requestly-#{version}#{arch}.dmg",
      verified: "github.comrequestlyrequestly-desktop-app"
  name "Requestly"
  desc "Intercept and modify HTTP requests"
  homepage "https:requestly.com"

  depends_on macos: ">= :high_sierra"

  app "Requestly.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.requestly*.sfl*",
    "~LibraryApplication SupportRequestly",
    "~LibraryLogsRequestly",
    "~LibraryPreferencesio.requestly.*.plist",
    "~LibrarySaved Application Stateio.requestly.*.savedState",
  ]
end