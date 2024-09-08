cask "requestly" do
  arch arm: "-arm64"

  version "1.7.3"
  sha256 arm:   "88c953dc56179fb8ef6c61a411ba123223bfd6c13b1efd5311c6d8931115c8ed",
         intel: "5f6491940f38e4472ad30124a26ccb9c6622498cf10776880cbc154e93189d45"

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