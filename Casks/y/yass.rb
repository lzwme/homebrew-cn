cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.12.0"
  sha256 arm:   "3d778516dc22bc08201d7d4dade6c4ccd96f8a8ab6d11862ef1afd473ab8eceb",
         intel: "d68bfcd8ef872f0ed505f5b789b10f3231b452ba0ac695e69631fe7e76af1096"

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