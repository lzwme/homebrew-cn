cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.1.4"
  sha256 arm:   "6e54072d96bc7ca2bf6d9c47a539db62b2049fe19dd04af33213a482ad97fad0",
         intel: "cd020ea0d125bb716ef5c5768c99eff81fb4a0192feeb19c2fa42fee041b12d9"

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