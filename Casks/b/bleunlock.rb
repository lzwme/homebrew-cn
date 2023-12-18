cask "bleunlock" do
  version "1.12.1"
  sha256 "d9847b2f540393bb2a18dc5be6929021c7499c383d12a198ee9f9e9ffada5f6b"

  url "https:github.comts1BLEUnlockreleasesdownload#{version}BLEUnlock-#{version}.zip"
  name "BLEUnlock"
  desc "Lockunlock Apple computers using the proximity of a bluetooth low energy device"
  homepage "https:github.comts1BLEUnlock"

  depends_on macos: ">= :high_sierra"

  app "BLEUnlock.app"

  zap trash: [
    "~LibraryApplication Scriptsjp.sone.BLEUnlock",
    "~LibraryCachesjp.sone.BLEUnlock",
    "~LibraryPreferencesjp.sone.BLEUnlock.plist",
  ]
end