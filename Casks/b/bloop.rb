cask "bloop" do
  arch arm: "aarch64", intel: "x64"

  version "0.5.10"
  sha256 arm:   "ad8d21aef94b90348e32255ee7c83aa9680f4b219fb6b45bfebd03e5f08367b0",
         intel: "30bebe04ed4044e47f10ecc96f7a2a8fdd4696a7bac5426bdedeee78830bfe2b"

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