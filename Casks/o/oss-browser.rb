cask "oss-browser" do
  version "1.18.0"
  sha256 "046e7aa50a76318b8ec8f5171ddb0cfcb8d80b6ad8134762331b874f80d685fb"

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