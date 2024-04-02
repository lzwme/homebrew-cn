cask "whisky" do
  version "2.2.4"
  sha256 "a902f53777b7f001216dabf636bd6658868abd65ba86b61d09be86903a4aa9a9"

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