cask "mockoon" do
  arch arm: "arm64", intel: "x64"

  version "8.2.0"
  sha256 arm:   "061c3566f5196652fa2bf733feb5708132a1e099690189c1ae6320567cbe2ccf",
         intel: "5819dc072100bc9c57dc9228f963819a2f1cf18c43c08fa4498687e4e4e4461e"

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
  depends_on macos: ">= :catalina"

  app "Mockoon.app"

  zap trash: [
    "~LibraryApplication Supportmockoon",
    "~LibraryLogsMockoon",
    "~LibraryPreferencescom.mockoon.app.plist",
    "~LibrarySaved Application Statecom.mockoon.app.savedState",
  ]
end