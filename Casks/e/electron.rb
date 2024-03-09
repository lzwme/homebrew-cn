cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.1.1"
  sha256 arm:   "584aea22fc600ab6b8c12c939045b6b1aec35ecc1187c3c85678da0af9890f9b",
         intel: "450e4e4b3e11b31e07225158249fdd96657e157772a1538c8d97cd786e10a58b"

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