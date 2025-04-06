cask "whisky" do
  version "2.3.5"
  sha256 "62fce6aa7034cc84e4809a35cb46af37e7932368102450dd2b3d4a18cbc7b94e"

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