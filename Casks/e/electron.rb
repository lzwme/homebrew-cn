cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.0.1"
  sha256 arm:   "7d7801beda834136a73baa165c6d6652558c9de4f45c5e1014051d64d92e5994",
         intel: "d06441f13ae2e8d48aef928ba58978744cbcb2f3f404ccd337d367b5d736c742"

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