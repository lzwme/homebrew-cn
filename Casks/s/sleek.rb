cask "sleek" do
  arch arm: "arm64", intel: "x64"

  version "2.0.12"
  sha256  arm:   "2ff7a193f67525b7be137f1eb9e07cb9c9f1da823cede5ddf08b0fd89185d903",
          intel: "e64bf9f4250e3787f839d4136d2d41e2ead01052f0eaa17c4cbe75a2c781bb13"

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