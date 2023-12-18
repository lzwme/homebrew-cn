cask "bespoke" do
  version "1.2.1"
  sha256 "85ca71302c002a14bc92958044797dbf0d8b9baa52a753243012347070f4e4bb"

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