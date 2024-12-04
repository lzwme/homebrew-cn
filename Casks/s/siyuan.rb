cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.14"
  sha256 arm:   "c36d5db01dd251fcbd4a6c773da8d656e64ff6c1620014eed71a1ed89bc4cc60",
         intel: "1508af4282af53fa0b08e8f172579cad5e52ec9f05e3c3a18b6912e9a6fedfc7"

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