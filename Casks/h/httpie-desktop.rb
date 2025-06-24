cask "httpie-desktop" do
  arch arm: "-arm64"

  version "2025.2.0"
  sha256 arm:   "4c0c73f115f37729124601c3843a74a38b45bbc9f82db3901cc53a6eae377b05",
         intel: "57f2fda42ac1ca41365338d606bf347b41da2433989487dc68831caf0bd7cf1b"

  url "https:github.comhttpiedesktopreleasesdownloadv#{version}HTTPie-#{version}#{arch}.dmg",
      verified: "github.comhttpiedesktop"
  name "HTTPie for Desktop"
  desc "Testing client for REST, GraphQL, and HTTP APIs"
  homepage "https:httpie.ioproduct"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "HTTPie.app"

  zap trash: [
    "~LibraryApplication SupportHTTPie",
    "~LibraryLogsHTTPie",
    "~LibraryPreferencesio.httpie.desktop.plist",
    "~LibrarySaved Application Stateio.httpie.desktop.savedState",
  ]
end