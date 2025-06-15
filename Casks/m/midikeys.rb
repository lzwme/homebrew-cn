cask "midikeys" do
  version "1.9.1"
  sha256 "c99bc47b141250b16672303a2530c99109bab9a6b52edfb5929433ece3c7cdf8"

  url "https:github.comflitMidiKeysreleasesdownloadv#{version}MidiKeys_#{version}.zip",
      verified: "github.comflitMidiKeys"
  name "MidiKeys"
  desc "Onscreen MIDI keyboard"
  homepage "https:www.manyetas.comcreedmidikeys.html"

  livecheck do
    url "https:immosw.comversionsmidikeysappcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "MidiKeys.app"

  zap trash: [
    "~LibraryHTTPStoragescom.immosw.MidiKeys",
    "~LibraryPreferencescom.immosw.MidiKeys.plist",
    "~LibrarySaved Application Statecom.immosw.MidiKeys.savedState",
  ]
end