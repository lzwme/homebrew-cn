cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.13.0"
  sha256 arm:   "eed7e9bc318f264b9645c219fcdfdd4eacef539b684758b3cfb138f5c8fc9230",
         intel: "0e74491045c13eaf31da94cda299d5d1c2fb557454842685caf9412bd9cc00c4"

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