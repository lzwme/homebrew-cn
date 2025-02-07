cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.34.0"
  sha256 arm:   "0fd348204f4532942de88db6e30f1308a540b8c3fdf834323a49d8bc15c99f6d",
         intel: "c3bd8caa8973b4ccf5580df228e28d8bcb7f768c4045257020422d12759be90d"

  url "https:github.comminbrowserminreleasesdownloadv#{version}min-v#{version}-mac-#{arch}.zip",
      verified: "github.comminbrowsermin"
  name "Min"
  desc "Minimal browser that protects privacy"
  homepage "https:minbrowser.github.iomin"

  depends_on macos: ">= :catalina"

  app "Min.app"

  zap trash: [
    "~LibraryApplication SupportMin",
    "~LibraryCachesMin",
    "~LibrarySaved Application Statecom.electron.min.savedState",
  ]
end