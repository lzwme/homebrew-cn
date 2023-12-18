cask "bitbar" do
  version "1.10.1"
  sha256 "8a7013dca92715ba80cccef98b84dd1bc8d0b4c4b603f732e006eb204bab43fa"

  url "https:github.commatryerbitbarreleasesdownloadv#{version}BitBar.app.zip"
  name "BitBar"
  desc "Utility to display the output from any script or program in the menu bar"
  homepage "https:github.commatryerbitbar"

  app "BitBar.app"

  zap trash: [
    "~LibraryBitBar Plugins",
    "~LibraryCachescom.matryer.BitBar",
    "~LibraryPreferencescom.matryer.BitBar.plist",
  ]
end