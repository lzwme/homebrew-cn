cask "koodo-reader" do
  arch arm: "arm64", intel: "x64"

  version "1.7.2"
  sha256 arm:   "911cd8738da1c75d76547ab2fe88c74f75f401306e512ec9b3b4dddbf3c8210b",
         intel: "dbe2434f40996e4e73a4ddc096be34e6036ebbf772d55c65ac0cf740bdb8beac"

  url "https:github.comtroyeguokoodo-readerreleasesdownloadv#{version}Koodo-Reader-#{version}-#{arch}.dmg",
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