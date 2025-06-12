cask "internxt-drive" do
  version "2.5.6.75"
  sha256 "1ce3f272d9677900c7680afe1b42ac3fe20530371588ea14f2d47bab05150bea"

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