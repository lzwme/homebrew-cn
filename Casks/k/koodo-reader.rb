cask "koodo-reader" do
  arch arm: "-arm64"

  version "1.5.1"
  sha256 arm:   "29939046e324835e2054d251e83f252992c51b5a45ae47bedeb2dd8d7cd82fa8",
         intel: "6f06f60bc5ef34e947be07874914641cddd6379fe676b11bcdbb79493c9a4d79"

  url "https:github.comtroyeguokoodo-readerreleasesdownloadv#{version}Koodo-Reader-#{version}#{arch}.dmg",
      verified: "github.comtroyeguokoodo-reader"
  name "Koodo Reader"
  desc "Open-source epub reader"
  homepage "https:koodo.960960.xyzen"

  livecheck do
    url :homepage
    regex(Stable\s*Version\s*v?(\d+(?:\.\d+)+)i)
  end

  app "Koodo Reader.app"

  zap trash: [
    "~LibraryApplication Supportkoodo-reader",
    "~LibraryPreferencesxyz.960960.koodo.plist",
    "~LibrarySaved Application Statexyz.960960.koodo.savedState",
  ]
end