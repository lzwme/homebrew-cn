cask "mockoon" do
  arch arm: "arm64", intel: "x64"

  version "8.1.1"
  sha256 arm:   "621f8a577c25ddc32aad81ee1e2514335d5bc82b2924727b9f26b45b6b399fcf",
         intel: "b57292ceaf47093cfc335d36dfa91f4570e00772709d762844700ea64cbbe986"

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