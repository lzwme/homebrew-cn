cask "sleek" do
  arch arm: "arm64", intel: "x64"

  version "2.0.13"
  sha256  arm:   "f20261971f93495cfca2eadf91e72affb3b2b28b0a5a618711f488f25655240e",
          intel: "04c11dc8257187bb0ab428a38e3d4cd249d6e91d50a0c6cbc07bb24abb0dceee"

  url "https:github.comransome1sleekreleasesdownloadv#{version}sleek-#{version}-mac-#{arch}.dmg"
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