cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.3.0"
  sha256 arm:   "b3145bbd45007918c2365b1df59a35b4d0636222cd43eea4803580de36b9a17d",
         intel: "88873a315ddd2a70b82e83f2cb7495c0d9d7c7fb5c9ad14fcfee16af4ab89d5e"

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