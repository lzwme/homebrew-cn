cask "tmpdisk" do
  version "2.0.6"
  sha256 "11f279ac2d142be90f4042a92f4f7da4b437bed80ac6963ecf68fc83524dd0b5"

  url "https:github.comimotheetmpdiskreleasesdownloadv#{version}TmpDisk.dmg"
  name "TmpDisk"
  desc "Ram disk management"
  homepage "https:github.comimotheetmpdisk"

  depends_on macos: ">= :mojave"

  app "TmpDisk.app"

  zap trash: "~LibraryPreferencescom.imothee.TmpDisk.plist"
end