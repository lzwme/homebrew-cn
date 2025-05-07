cask "internxt-drive" do
  version "2.5.5.74"
  sha256 "eae90156274c30ec603b0a2af1325ceb632524ac35f0dbb0043a7568c697a9d7"

  url "https:github.cominternxtdrive-desktop-macosreleasesdownloadv#{version}Internxt_Drive_#{version}.dmg",
      verified: "github.cominternxtdrive-desktop-macos"
  name "Internxt Drive"
  desc "Client for Internxt file storage service"
  homepage "https:internxt.comdrive"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Internxt Drive.app"

  zap trash: [
    "~.internxt-desktop",
    "~LibraryApplication Supportinternxt-drive",
    "~LibraryLogsInternxt Drive",
    "~LibraryLogsinternxt-drive",
    "~LibraryPreferencescom.internxt.drive.plist",
  ]
end