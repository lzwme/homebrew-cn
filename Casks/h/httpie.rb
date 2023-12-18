cask "httpie" do
  arch arm: "-arm64"

  version "2023.3.6"
  sha256 arm:   "72b53cf68a215f514651d917c13f53f62dd4ad2ec988bc132c00ece4a2249bea",
         intel: "d6cc25fc0837664267f19441cd18707d61b3437cc471136aa0b41df19838b7c5"

  url "https:github.comhttpiedesktopreleasesdownloadv#{version}HTTPie-#{version}#{arch}.dmg",
      verified: "github.comhttpiedesktop"
  name "HTTPie for Desktop"
  desc "Testing client for REST, GraphQL, and HTTP APIs"
  homepage "https:httpie.ioproduct"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "HTTPie.app"

  zap trash: [
    "~LibraryApplication SupportHTTPie",
    "~LibraryLogsHTTPie",
    "~LibraryPreferencesio.httpie.desktop.plist",
    "~LibrarySaved Application Stateio.httpie.desktop.savedState",
  ]
end