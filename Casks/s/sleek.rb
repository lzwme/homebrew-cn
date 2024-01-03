cask "sleek" do
  version "2.0.4"
  sha256 "453054e5646c01746e9ef52340256d4b2f650ab238a82545a12a1c5d67e7c0b4"

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