cask "bleunlock" do
  version "1.12.2"
  sha256 "9ceddc874cf519efc7411c8340abab9e1ff8a4b5b252eff6ca32a94b8cafef5b"

  url "https:github.comts1BLEUnlockreleasesdownload#{version}BLEUnlock-#{version}.zip"
  name "BLEUnlock"
  desc "Lockunlock Apple computers using the proximity of a bluetooth low energy device"
  homepage "https:github.comts1BLEUnlock"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "BLEUnlock.app"

  zap trash: [
    "~LibraryApplication Scriptsjp.sone.BLEUnlock",
    "~LibraryCachesjp.sone.BLEUnlock",
    "~LibraryPreferencesjp.sone.BLEUnlock.plist",
  ]
end