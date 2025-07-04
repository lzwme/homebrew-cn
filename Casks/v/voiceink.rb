cask "voiceink" do
  version "1.38"
  sha256 "c3db0d3b5edb8b6313f168e845e9abf591a0f3dfb32e3e946674428d4196d85c"

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