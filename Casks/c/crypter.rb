cask "crypter" do
  version "5.0.0"
  sha256 "ed136dbfacae87d52493e56e0e225d13203de997c54e7ac5f159feeadfcd4b7a"

  url "https:github.comHRCrypterreleasesdownloadv#{version}Crypter-#{version}.dmg"
  name "Crypter"
  desc "Encryption software"
  homepage "https:github.comHRCrypter"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-27", because: :unmaintained

  app "Crypter.app"

  zap trash: [
    "~LibraryApplication SupportCrypter",
    "~LibraryLogsCrypter",
    "~LibraryPreferencescom.github.hr.crypter.plist",
    "~LibrarySaved Application Statecom.github.hr.crypter.savedState",
  ]

  caveats do
    requires_rosetta
  end
end