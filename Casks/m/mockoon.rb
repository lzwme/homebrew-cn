cask "mockoon" do
  arch arm: "arm64", intel: "x64"

  version "9.3.0"
  sha256 arm:   "f45b92609902eeb2813c0ee44ef6ce8dc3480064c0422627213f79698358be20",
         intel: "df578f8d379fb96de6cee28abe3ff2db6215689e38032b5c9903267694ae2c0a"

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