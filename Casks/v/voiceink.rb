cask "voiceink" do
  version "1.25"
  sha256 "92bbbcd3f9368f943288f6965f200924558548b0f5065b1393beed4090dc92bf"

  url "https:github.comBeingpaxVoiceInkreleasesdownloadv#{version}VoiceInk.dmg",
      verified: "github.comBeingpaxVoiceInk"
  name "VoiceInk"
  desc "Voice to text app"
  homepage "https:tryvoiceink.com"

  livecheck do
    url "https:beingpax.github.ioVoiceInkappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "VoiceInk.app"

  zap trash: [
    "~LibraryApplication Supportcom.prakashjoshipax.VoiceInk",
    "~LibraryApplication SupportVoiceInk",
    "~LibraryCachescom.prakashjoshipax.VoiceInk",
    "~LibraryHTTPStoragescom.prakashjoshipax.VoiceInk",
    "~LibraryPreferencescom.prakashjoshipax.VoiceInk.plist",
    "~LibrarySaved Application Statecom.prakashjoshipax.VoiceInk.savedState",
  ]
end