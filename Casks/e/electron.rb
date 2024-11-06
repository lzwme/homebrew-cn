cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "33.1.0"
  sha256 arm:   "9501f835ede52a715e2c9fd01f591a9771d0029a2cf37fc47fa02e62329f061c",
         intel: "225f57a30b88cedbf814687526c9450f9a8862fa7b57a1ccc5227b0a76818f2d"

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