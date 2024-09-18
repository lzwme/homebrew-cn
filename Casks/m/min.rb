cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.33.1"
  sha256 arm:   "4ec8a6cdb73cf18175b9aa0e720b8765b439e514062739b062ef9789ca782b40",
         intel: "265be622edcb6682945608c4415cfb983d495ffd62e10061e0cab48ce07e7a12"

  url "https:github.comminbrowserminreleasesdownloadv#{version}min-v#{version}-mac-#{arch}.zip",
      verified: "github.comminbrowsermin"
  name "Min"
  desc "Minimal browser that protects privacy"
  homepage "https:minbrowser.github.iomin"

  app "Min.app"

  zap trash: [
    "~LibraryApplication SupportMin",
    "~LibraryCachesMin",
    "~LibrarySaved Application Statecom.electron.min.savedState",
  ]
end