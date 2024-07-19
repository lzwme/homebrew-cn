cask "requestly" do
  arch arm: "-arm64"

  version "1.7.1"
  sha256 arm:   "b8ed5448293e152e1f206b028e06b62f114a0235520e4e526363c11dd7a6c7c1",
         intel: "fff307967667a34544f864f27feb876a62ba10f40bd5d5965cf85dfdba6254f3"

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