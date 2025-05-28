cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.31"
  sha256 arm:   "375b913f9d8eeaf4727e2c84ffa4365309083f83acdf17cbbaa8459f796b7369",
         intel: "c5236f5a99c1a315e760686482ea16eae035b2229ee4147e483ba6a7606741a7"

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