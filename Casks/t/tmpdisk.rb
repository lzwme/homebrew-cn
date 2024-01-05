cask "tmpdisk" do
  version "2.0.7"
  sha256 "91f8389fa88192e9edda8880643d4b9994ab7bc6b1ad99981a52ea7535325eea"

  url "https:github.comimotheetmpdiskreleasesdownloadv#{version}TmpDisk.dmg"
  name "TmpDisk"
  desc "Ram disk management"
  homepage "https:github.comimotheetmpdisk"

  depends_on macos: ">= :mojave"

  app "TmpDisk.app"

  zap trash: "~LibraryPreferencescom.imothee.TmpDisk.plist"
end