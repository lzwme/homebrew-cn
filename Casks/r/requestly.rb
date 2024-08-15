cask "requestly" do
  arch arm: "-arm64"

  version "1.7.2"
  sha256 arm:   "67480312dce34a27b2962c7e91f18b4746ea0bf4b59adcd3139f4c7e402c51f0",
         intel: "2acf2431e1bef6b936094802e11a799a4638a8d768c3d4082dcfbf1775b93015"

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