cask "sleek" do
  version "2.0.3"
  sha256 "ae23a4e7a7ba0cab66a8e56c581ba4b9e09c77b4ed6085aa854df4534383682d"

  url "https:github.comransome1sleekreleasesdownloadv#{version}sleek-#{version}-mac.dmg"
  name "sleek"
  desc "Todo manager based on the todo.txt syntax"
  homepage "https:github.comransome1sleek"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "sleek.app"

  zap trash: [
    "~LibraryApplication Supportsleek",
    "~LibraryPreferencescom.todotxt.sleek.plist",
    "~LibrarySaved Application Statecom.todotxt.sleek.savedState",
  ]
end