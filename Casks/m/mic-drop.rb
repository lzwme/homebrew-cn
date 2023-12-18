cask "mic-drop" do
  version "1.4.6"
  sha256 "24bac5d600f30eacbbfed2094cc674feea5286a009c32821edafece0fc465fdf"

  url "https:github.comoctopusthinkgetmicdrop.comreleasesdownloadv#{version}Mic.Drop.#{version}.zip",
      verified: "github.comoctopusthinkgetmicdrop.com"
  name "Mic Drop"
  desc "Quickly mute your microphone with a global shortcut or menu bar control"
  homepage "https:getmicdrop.com"

  livecheck do
    url "https:getmicdrop.comdownloadsappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Mic Drop.app"

  zap trash: [
    "~LibraryApplication Supportcom.octopusthink.Mic-Drop",
    "~LibraryApplication SupportMic Drop",
    "~LibraryCachescom.octopusthink.Mic-Drop",
    "~LibraryPreferencescom.octopusthink.Mic-Drop.plist",
  ]
end