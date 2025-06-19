cask "voiceink" do
  version "1.34"
  sha256 "aa36c5ca8ca566baf11e07eed5b005700109a705eefd7e1d06faa1a250177936"

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