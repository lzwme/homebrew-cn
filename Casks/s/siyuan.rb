cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.5"
  sha256 arm:   "91f96f7569660b80c02baffda008e9506b2edfcc33c3ec8838d98d5f7dfb6053",
         intel: "de7c60e76e3a5c0468cb5c6350c0ce4758152881dfa252e7b67766a78e339023"

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