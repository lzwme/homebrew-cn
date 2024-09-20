cask "whisky" do
  version "2.3.3"
  sha256 "385ed9ec848c1b057291b8bdf801cf6bf7e3eed9bdf3ac1a5a44b9c82fdc4034"

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
    "~LibraryApplication Scriptscom.isaacmarovitz.Whisky.WhiskyThumbnail",
    "~LibraryApplication Supportcom.isaacmarovitz.Whisky",
    "~LibraryContainerscom.isaacmarovitz.Whisky",
    "~LibraryContainerscom.isaacmarovitz.Whisky.WhiskyThumbnail",
    "~LibraryHTTPStoragescom.isaacmarovitz.Whisky",
    "~LibraryLogscom.isaacmarovitz.Whisky",
    "~LibraryPreferencescom.isaacmarovitz.Whisky.plist",
    "~LibrarySaved Application Statecom.isaacmarovitz.Whisky.savedState",
  ]
end