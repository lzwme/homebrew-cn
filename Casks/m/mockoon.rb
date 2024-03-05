cask "mockoon" do
  version "7.0.0"
  sha256 "3117beba50532d203e7d61d9e17af09abab251ec7628df391006d2f86664d28e"

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