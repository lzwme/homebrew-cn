cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.31.0"
  sha256 arm:   "8370ee00dd7ef0b9a830d58abbf81f85b58d220df74c8228cb797a232484cea5",
         intel: "f1c76a78513fdcd69846abb9c145604ccb97cab2120b648523f5b4e2d20535fb"

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