cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.14.0"
  sha256 arm:   "7dc08ad0a6dc0da8ffc91349fd5c647942aa7a308917a675cdc2e2c2487a341b",
         intel: "e0a6d9da63df421bed2315f2cae4ab66d5dadaa4c0776ae2c9a0ee8eeb752684"

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