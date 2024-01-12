cask "sleek" do
  version "2.0.6"
  sha256 "4d9e84e7faf4b0558db711fedfa3b6f10c4a0cbcaa43ac3c721585ead816b1dd"

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