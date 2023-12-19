cask "bloop" do
  arch arm: "aarch64", intel: "x64"

  version "0.5.11"
  sha256 arm:   "b8f02a26ebfd737b892bfce2418bcf5b0b3a5c46f5b57c6be4c4b327355cbb71",
         intel: "d54c68e0dd9e9d41f24f0aeb15591546e7430c77720a24d4342f0cdc6ba806cc"

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