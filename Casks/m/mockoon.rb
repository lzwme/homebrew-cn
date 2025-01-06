cask "mockoon" do
  arch arm: "arm64", intel: "x64"

  version "9.1.0"
  sha256 arm:   "98c3f6a6bade4a5ae9d3f1aa7eac9d0bf48fc07f7fbdb550529c1af3400bda5d",
         intel: "7bf944ee1a28f101ad530d7d90d35538e222a1ac536f0bdc580a43b5ca44092b"

  url "https:github.commockoonmockoonreleasesdownloadv#{version}mockoon.setup.#{version}.#{arch}.dmg",
      verified: "github.commockoonmockoon"
  name "Mockoon"
  desc "Create mock APIs in seconds"
  homepage "https:mockoon.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Mockoon.app"

  zap trash: [
    "~LibraryApplication Supportmockoon",
    "~LibraryLogsMockoon",
    "~LibraryPreferencescom.mockoon.app.plist",
    "~LibrarySaved Application Statecom.mockoon.app.savedState",
  ]
end