cask "whisky" do
  version "2.2.1"
  sha256 "ba819ff9424648162345b9410ab01b19b2ef58cedb5abfd8d28d2c83c169a65a"

  url "https:github.comIsaacMarovitzWhiskyreleasesdownloadv#{version}Whisky.zip"
  name "Whisky"
  desc "Wine wrapper built with SwiftUI"
  homepage "https:github.comIsaacMarovitzWhisky"

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