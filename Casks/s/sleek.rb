cask "sleek" do
  version "2.0.5"
  sha256 "1b2dd7ae854d76d469b2f15ca5472d0560bc5ce4a5ca782e5513b01874b26d98"

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