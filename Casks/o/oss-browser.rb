cask "oss-browser" do
  version "1.17.0"
  sha256 "457743b705524bfbdf9e60d345dfac2533d4eae93b47e3abbebe5d156a3f89a9"

  url "https:github.comaliyunoss-browserreleasesdownloadv#{version}oss-browser-darwin-x64.zip"
  name "oss-browser"
  desc "Graphical management tool for OSS (Object Storage Service)"
  homepage "https:github.comaliyunoss-browser"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "oss-browser-darwin-x64oss-browser.app"

  zap trash: [
    "~.oss-browser",
    "~LibraryApplication Supportoss-browser",
    "~LibraryLogsoss-browser",
    "~LibraryPreferencescom.electron.oss-browser.helper.plist",
    "~LibraryPreferencescom.electron.oss-browser.plist",
    "~LibrarySaved Application Statecom.electron.oss-browser.savedState",
  ]
end