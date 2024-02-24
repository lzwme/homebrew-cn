cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.31.2"
  sha256 arm:   "b08b75e22a0009b28237ba6ed04d3747faa9cbd5f973d6aad715b89af4170ac2",
         intel: "5bd06adf8f02a86f3d5407eeb7c8a1a790cdc3a571a9cbf6c92da48d066ec06b"

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