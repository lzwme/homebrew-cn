cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.12.1"
  sha256 arm:   "3895252d62540ffb5e62228120829267ddd7f6e6c42f6f153c7d22effa7801fe",
         intel: "c1c592132bab5a004ccebc439b974926d66069dc40647d19dbd3541d33ee5468"

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