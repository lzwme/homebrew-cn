cask "whisky" do
  version "2.3.1"
  sha256 "a8b398d576c8199ca0a8116e881b0ffcac6be1fb4b34d087f6ca69c57584371c"

  url "https:github.comIsaacMarovitzWhiskyreleasesdownloadv#{version}Whisky.zip",
      verified: "github.comIsaacMarovitzWhisky"
  name "Whisky"
  desc "Wine wrapper built with SwiftUI"
  homepage "https:getwhisky.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "Whisky.app"
  binary "#{appdir}Whisky.appContentsResourcesWhiskyCmd", target: "whisky"

  zap trash: [
    "~LibraryApplication Supportcom.isaacmarovitz.Whisky",
    "~LibraryContainerscom.isaacmarovitz.Whisky",
    "~LibraryHTTPStoragescom.isaacmarovitz.Whisky",
    "~LibraryLogscom.isaacmarovitz.Whisky",
    "~LibraryPreferencescom.isaacmarovitz.Whisky.plist",
    "~LibrarySaved Application Statecom.isaacmarovitz.Whisky.savedState",
  ]
end