cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.11.4"
  sha256 arm:   "90fa61a5301cd3f8eb20b03f65064a16cf0721e57f9e09ca6ea761aef385923b",
         intel: "b79c8449b3058c4a7cf231c6ee97138c650fd90528ab9b4678c27a1929d9606c"

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