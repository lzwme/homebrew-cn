cask "mic-drop" do
  version "1.5.0"
  sha256 "be01a9de5ef716e10d2885def7d2ead92799a68fa62c5f32a257a0ae2580b0bd"

  url "https:github.comoctopusthinkgetmicdrop.comreleasesdownloadv#{version}Mic.Drop.#{version}.zip",
      verified: "github.comoctopusthinkgetmicdrop.com"
  name "Mic Drop"
  desc "Quickly mute your microphone with a global shortcut or menu bar control"
  homepage "https:getmicdrop.com"

  deprecate! date: "2024-10-08", because: :moved_to_mas

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