cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.9.4"
  sha256 arm:   "e655af89081dfd5c4981508f71080816b38aa8a268e700820f9b49555b7fc415",
         intel: "aa1d6b9715fed3de116e2b06afbd5b22c4d22537fd240b9fdb1929bdd99c13bf"

  url "https:github.comChilledheartyassreleasesdownload#{version}yass-macos-release#{arch}-#{version}.dmg"
  name "YASS"
  desc "Yet Another Shadow Socket"
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