cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.11.1"
  sha256 arm:   "e6067281fd68b885891b96ea991b393dd64d6c2817d0d79581500df779bf1d1c",
         intel: "5a47d45c092125ef01248748221488b619717f2baa68f50c83871da1072d78ca"

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