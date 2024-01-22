cask "sleek" do
  version "2.0.7"
  sha256 "9c86fdca41243befb71876d7e67ff8119eba9069b05007920eb6484faa819d00"

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