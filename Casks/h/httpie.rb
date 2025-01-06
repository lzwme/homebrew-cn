cask "httpie" do
  arch arm: "-arm64"

  version "2024.1.2"
  sha256 arm:   "62e1f5287161927573690ac72e9611856ae968e1d0d2792d0be2cd9a548a5ffa",
         intel: "ccf09fc34080f44e093922b55fb28f888e11fb3f49d705c39d7218c295293495"

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