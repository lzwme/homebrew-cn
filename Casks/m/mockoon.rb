cask "mockoon" do
  version "6.1.0"
  sha256 "dbdf1ab2faec0c39ea61f0e6e82a8fcb905deff220263f38af504a83119bde57"

  url "https:github.commockoonmockoonreleasesdownloadv#{version}mockoon.setup.#{version}.universal.dmg",
      verified: "github.commockoonmockoon"
  name "Mockoon"
  desc "Create mock APIs in seconds"
  homepage "https:mockoon.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Mockoon.app"

  zap trash: [
    "~LibraryApplication Supportmockoon",
    "~LibraryLogsMockoon",
    "~LibraryPreferencescom.mockoon.app.plist",
    "~LibrarySaved Application Statecom.mockoon.app.savedState",
  ]
end