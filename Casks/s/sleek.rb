cask "sleek" do
  arch arm: "arm64", intel: "x64"

  version "2.0.11"
  sha256  arm:   "7d3894a4c6363067c1f47eaf6a6224b2f01e57af51dad361de958fee3a82600e",
          intel: "67856c3faf317e8447dec35944b11a51e2f8f1e1a6b4bccb27e8ac474790d01d"

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