cask "requestly" do
  arch arm: "-arm64"

  version "1.7.4"
  sha256 arm:   "6537d1735bd45b848264134aa83d8b4bf7388c0f291e57b0b5dab6c72fbf632a",
         intel: "4ffbbb3bc33e2c62a81322d085b78cb31d5ce17bf0c6056d8cdbffd81d7d19bd"

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