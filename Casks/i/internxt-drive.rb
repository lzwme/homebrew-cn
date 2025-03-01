cask "internxt-drive" do
  version "2.5.3.72"
  sha256 "4147532760ab82baf5d77729879595472a1651e517a717be3ba596c221bc3a15"

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