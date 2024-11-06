cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.11"
  sha256 arm:   "735d2ff32306c34b3d1151fa7f645d93bd596bd9459b65f21f321ef75824237d",
         intel: "b75e6e592adf4ca474230c72fc8fab0c54ed641b1772e6f36a92d78f87ea10a8"

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