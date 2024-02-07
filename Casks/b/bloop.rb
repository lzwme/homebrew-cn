cask "bloop" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.2"
  sha256 arm:   "2a2bababe1d92a8e157a4f999d5268b4bfb25148dd3bb9faa3e8dbc3c084b8b3",
         intel: "e1adfe376768a3809c1f6198508eff95d9aab6d9cb74fe9b54442fc9eeb08c78"

  url "https:github.comBloopAIbloopreleasesdownloadv#{version}bloop_#{version}_#{arch}.dmg",
      verified: "github.comBloopAIbloop"
  name "bloop"
  desc "Code search engine"
  homepage "https:bloop.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "bloop.app"

  zap trash: [
    "~LibraryCachesai.bloop.bloop",
    "~LibraryPreferencesai.bloop.bloop.plist",
    "~LibrarySaved Application Stateai.bloop.bloop.savedState",
    "~LibraryWebKitai.bloop.bloop",
  ]
end