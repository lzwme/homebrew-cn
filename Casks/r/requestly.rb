cask "requestly" do
  arch arm: "-arm64"

  version "25.4.13"
  sha256 arm:   "1044781a29e60a09002763f44d84b8d81c439b26481c7fcb31524468a5964018",
         intel: "fb7c2843a7d0e929cacaf06967740104b08bd7f0e32eb17706066c167d6b5a6a"

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