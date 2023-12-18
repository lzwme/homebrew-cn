cask "androidtool" do
  version "1.66"
  sha256 "4f432ad45660071a1f36c4878bd444dd8bedd520c7c70096e5d7a7907ff7c86a"

  url "https:github.commortenjustandroidtool-macreleasesdownload#{version}AndroidTool.zip"
  name "AndroidTool"
  desc "App for recording the screen and installing apps in iOS and Android"
  homepage "https:github.commortenjustandroidtool-mac"

  app "AndroidTool.app"

  zap trash: [
    "~LibraryApplication SupportAndroidTool",
    "~LibraryPreferencescom.mortenjust.AndroidTool.plist",
    "~LibrarySaved Application Statecom.mortenjust.AndroidTool.savedState",
  ]
end