cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "32.0.0"
  sha256 arm:   "f0dae4b47af64fcfd83123f3c98c9c02f8f8064fb1d56cd295c0347234157b48",
         intel: "685d791c4635194a84119c35671002590c829f13001bbf222d7b2ccd07bb8862"

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