cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.31.1"
  sha256 arm:   "d6e7ec82fc4c0500c4b7db872d63dde15148e64476ecdf3af8e38fc4f8c25c20",
         intel: "459a4781fca2d2fc51484526ceca0c63e7c9ec1fc0aedaf2f6283519a3875448"

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