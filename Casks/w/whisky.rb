cask "whisky" do
  version "2.3.2"
  sha256 "75136176947df9701c6387fdc3420f29ec0414e845304e2582b17f62dfeb805f"

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