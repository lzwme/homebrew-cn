cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "31.0.1"
  sha256 arm:   "68f90a6c6f1f8f616ee65f820f7c95394782c0e34775f9a81a6a6c628134dc3f",
         intel: "7bb127f2c7d900ba15d40e2f21462f546e4d7a4461add8fd2ac7164df836e191"

  url "https:github.comelectronelectronreleasesdownloadv#{version}electron-v#{version}-darwin-#{arch}.zip",
      verified: "github.comelectronelectron"
  name "Electron"
  desc "Build desktop apps with JavaScript, HTML, and CSS"
  homepage "https:electronjs.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Electron.app"
  binary "#{appdir}Electron.appContentsMacOSElectron", target: "electron"

  zap trash: [
    "~LibraryApplication SupportElectron",
    "~LibraryCachesElectron",
    "~LibraryPreferencescom.github.electron.helper.plist",
    "~LibraryPreferencescom.github.electron.plist",
  ]
end