cask "journey" do
  version "2.14.6"
  sha256 "19da0e4da7983f54c1dabd7bc8bfb03ff8d783ad02a4fb9701b4f2891450e44a"

  url "https:github.com2-App-Studiojourney-releasesreleasesdownloadv#{version}Journey-darwin-#{version}.zip",
      verified: "github.com2-App-Studiojourney-releases"
  name "Journey"
  desc "Diary app"
  homepage "https:2appstudio.comjourney"

  auto_updates true

  app "Journey.app"

  zap trash: [
    "~LibraryApplication SupportJourney#{version.major}",
    "~LibraryPreferencescom.journey.mac#{version.major}.helper.plist",
    "~LibraryPreferencescom.journey.mac#{version.major}.plist",
    "~LibrarySaved Application Statecom.journey.mac#{version.major}.savedState",
  ]
end