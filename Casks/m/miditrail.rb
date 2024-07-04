cask "miditrail" do
  version "2.0.2"
  sha256 "15204f7c61703b66c053fc96b6552f53a53b192c3c05c1a4c5a93bd2ce640281"

  url "https:github.comwdmssMIDITrail-macOSreleasesdownloadv#{version}MIDITrail-Ver.#{version}-macOS.zip",
      verified: "github.comwdmssMIDITrail-macOS"
  name "MIDITrail"
  desc "MIDI player which provides 3D visualization of MIDI data sets"
  homepage "https:www.yknk.orgmiditrailen"

  depends_on macos: ">= :sierra"

  app "MIDITrailMIDITrail.app"

  zap trash: [
    "~LibraryPreferencesjp.sourceforge.users.yknk.MIDITrail.plist",
    "~LibrarySaved Application Statejp.sourceforge.users.yknk.MIDITrail.savedState",
  ]
end