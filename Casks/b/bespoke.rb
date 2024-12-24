cask "bespoke" do
  version "1.3.0"
  sha256 "f31f37593fb4e1981701775be8bc1b700608d1ce3ddbdc4da336615d5eff79b6"

  url "https:github.comBespokeSynthBespokeSynthreleasesdownloadv#{version}BespokeSynth-Mac-#{version.dots_to_underscores}.dmg",
      verified: "github.comBespokeSynthBespokeSynth"
  name "Bespoke Synth"
  desc "Software modular synth"
  homepage "https:www.bespokesynth.com"

  app "BespokeSynth.app"

  zap trash: [
    "~LibraryCachescom.ryanchallinor.bespokesynth",
    "~LibraryPreferencescom.ryanchallinor.bespokesynth.plist",
    "~LibrarySaved Application Statecom.ryanchallinor.bespokesynth.savedState",
  ]
end