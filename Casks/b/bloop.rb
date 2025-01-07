cask "bloop" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.5"
  sha256 arm:   "81f57e777ba61dc04ce1b22c2903d144c4b97beea532415f53a8f30e41b01b68",
         intel: "7a8a10b4cb89dcb327217ec644fa1c9e62db732229e2d23b2a723d8def714bf0"

  url "https:github.comBloopAIbloopreleasesdownloadv#{version}bloop_#{version}_#{arch}.dmg",
      verified: "github.comBloopAIbloop"
  name "bloop"
  desc "Code search engine"
  homepage "https:bloop.ai"

  deprecate! date: "2025-01-05", because: :discontinued

  depends_on macos: ">= :big_sur"

  app "bloop.app"

  zap trash: [
    "~LibraryCachesai.bloop.bloop",
    "~LibraryPreferencesai.bloop.bloop.plist",
    "~LibrarySaved Application Stateai.bloop.bloop.savedState",
    "~LibraryWebKitai.bloop.bloop",
  ]
end