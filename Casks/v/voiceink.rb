cask "voiceink" do
  version "1.33"
  sha256 "ea39c9e469cd5a23ab6745ee69da8ff613fc7cf309d6bd196d3ff2b20feb95e3"

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