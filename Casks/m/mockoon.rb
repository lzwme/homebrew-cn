cask "mockoon" do
  version "6.0.1"
  sha256 "82f86d65c47c90aec934f2cf8d542edf5ac92638e366a2e031425d3573dab141"

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

  app "Mockoon.app"

  zap trash: [
    "~LibraryApplication Supportmockoon",
    "~LibraryLogsMockoon",
    "~LibraryPreferencescom.mockoon.app.plist",
    "~LibrarySaved Application Statecom.mockoon.app.savedState",
  ]
end