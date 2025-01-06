cask "tmpdisk" do
  version "2.1.0"
  sha256 "509ad4ecd945dbf438ec29a2f1685a4974ade31f0786147cec424ee2d71e14de"

  url "https:github.comimotheetmpdiskreleasesdownloadv#{version}TmpDisk.dmg"
  name "TmpDisk"
  desc "Ram disk management"
  homepage "https:github.comimotheetmpdisk"

  depends_on macos: ">= :big_sur"

  app "TmpDisk.app"

  zap trash: "~LibraryPreferencescom.imothee.TmpDisk.plist"
end