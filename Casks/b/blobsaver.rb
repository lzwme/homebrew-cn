cask "blobsaver" do
  arch arm: "arm", intel: "intel"

  version "3.6.0"
  sha256 arm:   "bd80e6cf9d1d68a91ebdc4a8023c87203da2db63863b2a16845150f7e990f02f",
         intel: "2820b333dbf7df9ddc92132a099496b533cabf11c151b4c875f7cd4f385ba70c"

  url "https:github.comairsquaredblobsaverreleasesdownloadv#{version}blobsaver-#{arch}-#{version}.dmg"
  name "blobsaver"
  desc "GUI for automatically saving SHSH blobs"
  homepage "https:github.comairsquaredblobsaver"

  app "blobsaver.app"
  binary "#{appdir}blobsaver.appContentsMacOSblobsaver"

  zap trash: "~LibraryPreferencesairsquared.blobsaver.app.plist"
end