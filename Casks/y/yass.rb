cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.9.5"
  sha256 arm:   "ee5b936d9799c116600e0ffde9d4b91bfc8ed263adef8d4be32c7715c27acf3a",
         intel: "18e5e88dc23e9da472c49d20a7949dea378609bee84b466bf484a90527a1e179"

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