cask "requestly" do
  arch arm: "-arm64"

  version "1.8.0"
  sha256 arm:   "b61ed40170087f443ae49db5a8d4592b5c5d8aa9f3c5cff672b722312170fef5",
         intel: "e8b2aac08734643d7856e245c217398e6b9ddc638bf115fd9784e305348ad574"

  url "https:github.comrequestlyrequestly-desktop-appreleasesdownloadv#{version}Requestly-#{version}#{arch}.dmg",
      verified: "github.comrequestlyrequestly-desktop-app"
  name "Requestly"
  desc "Intercept and modify HTTP requests"
  homepage "https:requestly.com"

  livecheck do
    url :url
    strategy :github_latest
  end

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