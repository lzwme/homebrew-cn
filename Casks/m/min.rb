cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.33.0"
  sha256 arm:   "4960f9dc258ba80d7933cc4c1322064cf891d56d38cab03d650b45b1af63c078",
         intel: "1b8256b0714f5e065541b451afec3d775517cac855e519c96b50bbca53effdc3"

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