cask "mockoon" do
  arch arm: "arm64", intel: "x64"

  version "9.2.0"
  sha256 arm:   "39d66cb88bc9f697b9bfd7127a1593e90b727f5b48c45386bcd56d4dc94f42d1",
         intel: "4709e80c61ff566bb71ac3c69a6619434731350dfe77065f8699d85a73328cd2"

  url "https:github.commockoonmockoonreleasesdownloadv#{version}mockoon.setup.#{version}.#{arch}.dmg",
      verified: "github.commockoonmockoon"
  name "Mockoon"
  desc "Create mock APIs in seconds"
  homepage "https:mockoon.com"

  livecheck do
    url "https:api.mockoon.comreleasesdesktopstable.json"
    strategy :json do |json|
      json["tag"]
    end
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