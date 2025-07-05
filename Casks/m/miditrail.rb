cask "miditrail" do
  version "2.0.2"
  sha256 "15204f7c61703b66c053fc96b6552f53a53b192c3c05c1a4c5a93bd2ce640281"

  url "https://ghfast.top/https://github.com/wdmss/MIDITrail-macOS/releases/download/v#{version}/MIDITrail-Ver.#{version}-macOS.zip",
      verified: "github.com/wdmss/MIDITrail-macOS/"
  name "MIDITrail"
  desc "MIDI player which provides 3D visualization of MIDI data sets"
  homepage "https://www.yknk.org/miditrail/en/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "MIDITrail/MIDITrail.app"

  zap trash: [
    "~/Library/Preferences/jp.sourceforge.users.yknk.MIDITrail.plist",
    "~/Library/Saved Application State/jp.sourceforge.users.yknk.MIDITrail.savedState",
  ]
end