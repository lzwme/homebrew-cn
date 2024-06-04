cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.17"
  sha256 arm:   "389d9fd85f5f29e79dd527ecaa2672f892e72a58adaf470865e57852c1f064e1",
         intel: "04f96992a0ca6cd864763288b2b441be9ebc147ae55b104c529f155af3d015f0"

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