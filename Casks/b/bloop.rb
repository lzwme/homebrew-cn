cask "bloop" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.4"
  sha256 arm:   "28d05df295957db5ac24b1899fcba6ffa4e37bb31fcc45aa94660569555333ba",
         intel: "4f5ae8bf707f54df8e4ebff7616c09974f481dfdab55864ac0e46f02de08aec6"

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