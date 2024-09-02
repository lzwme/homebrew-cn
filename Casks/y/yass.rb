cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.13.1"
  sha256 arm:   "917b87ad329bef6fbf57c6715aa954aacd1d6799fd0831d01131f6f37bbd5513",
         intel: "be704526993bac728f25ff4b13d4a82b7bb8a013430692cb518d1f73f1681222"

  url "https:github.comChilledheartyassreleasesdownload#{version}yass-macos-release#{arch}-#{version}.dmg"
  name "Yet Another Shadow Socket"
  desc "Lightweight and efficient, sockshttp forward proxy"
  homepage "https:github.comChilledheartyass"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "yass.app"
  binary "#{appdir}yass.appContentsMacOSyass"

  zap trash: [
    "~LibraryPreferencesit.gui.yass.plist",
    "~LibraryPreferencesit.gui.yass.suite.plist",
  ]
end