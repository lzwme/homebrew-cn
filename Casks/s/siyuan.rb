cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.6"
  sha256 arm:   "6e99db064ead3ee9c3a2c9d1456353be5aefa57b839cdf9ca68c26bbe55f2c8b",
         intel: "7f41ef483f520716c18f95c340ed5d51016f61b03b738dc3d4f8630eff2b26e7"

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