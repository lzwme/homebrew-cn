cask "voiceink" do
  version "1.30"
  sha256 "458a29e5831c185aba8e8ea7cb916919e5e669eb85c82a0247f49b26037d9f5d"

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