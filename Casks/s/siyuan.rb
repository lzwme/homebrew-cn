cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.8"
  sha256 arm:   "c7d9cd49ae94ea4db09df5e7095d0ce549e32c41d79b1b924e6421fab7e2e8dc",
         intel: "7ad243578210f481797d303981859cd296cd40bf63447c84119997b2fb2b700a"

  url "https:github.comsiyuan-notesiyuanreleasesdownloadv#{version}siyuan-#{version}-mac#{arch}.dmg"
  name "SiYuan"
  desc "Local-first personal knowledge management system"
  homepage "https:github.comsiyuan-notesiyuan"

  app "SiYuan.app"

  zap trash: [
    "~.siyuan",
    "~LibraryApplication SupportSiYuan",
    "~LibraryPreferencesorg.b3log.siyuan.plist",
    "~LibrarySaved Application Stateorg.b3log.siyuan.savedState",
  ]
end