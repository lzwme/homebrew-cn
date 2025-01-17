cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.20"
  sha256 arm:   "d7e7ba73178c68bd35283c669e325fde894fae66947a70f9807e4c156e3b20e7",
         intel: "82c25ad7e6c75dc66c46d7ddb572647731aea9d31d0ece3681185b1672cd2d52"

  url "https:github.comsiyuan-notesiyuanreleasesdownloadv#{version}siyuan-#{version}-mac#{arch}.dmg"
  name "SiYuan"
  desc "Local-first personal knowledge management system"
  homepage "https:github.comsiyuan-notesiyuan"

  depends_on macos: ">= :catalina"

  app "SiYuan.app"

  zap trash: [
    "~.siyuan",
    "~LibraryApplication SupportSiYuan",
    "~LibraryPreferencesorg.b3log.siyuan.plist",
    "~LibrarySaved Application Stateorg.b3log.siyuan.savedState",
  ]
end