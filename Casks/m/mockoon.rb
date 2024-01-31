cask "mockoon" do
  version "6.2.0"
  sha256 "7b2ea429b61044b55488bf5cddec961f2d533d15ddbd97006bfc2a7b72ae458e"

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