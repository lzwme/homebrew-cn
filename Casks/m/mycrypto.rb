cask "mycrypto" do
  version "1.7.17"
  sha256 "8fe2652697b0557f7e221d0c960aa9e36a54445f12e7396a193cc5c5ad6ded06"

  url "https:github.comMyCryptoHQMyCryptoreleasesdownload#{version}mac_#{version}_MyCrypto.dmg",
      verified: "github.comMyCryptoHQMyCrypto"
  name "MyCrypto"
  desc "Ethereum wallet manager"
  homepage "https:mycrypto.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "MyCrypto.app"

  zap trash: [
    "~LibraryApplication SupportMyCrypto",
    "~LibraryLogsMyCrypto",
    "~LibraryPreferencescom.github.mycrypto.mycryptohq.helper.plist",
    "~LibraryPreferencescom.github.mycrypto.mycryptohq.plist",
    "~LibrarySaved Application Statecom.github.mycrypto.mycryptohq.savedState",
  ]

  caveats do
    requires_rosetta
  end
end