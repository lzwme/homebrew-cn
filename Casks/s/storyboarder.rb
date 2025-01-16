cask "storyboarder" do
  arch arm: "-arm64"

  version "3.0.0"
  sha256 arm:   "72fe80f916b6a01b65311f480776af68ec919eff87c33ca4807c9049dcaa8f73",
         intel: "3cb5a0ec67a28c4c0d6a3b030d2031f7e5c4238ba8b3b0e8173435501fa9f632"

  url "https:github.comwonderunitstoryboarderreleasesdownloadv#{version}Storyboarder-#{version}#{arch}.dmg",
      verified: "github.comwonderunitstoryboarder"
  name "Wonder Unit Storyboarder"
  desc "Visualise a story as fast you can draw stick figures"
  homepage "https:wonderunit.comstoryboarder"

  app "Storyboarder.app"

  zap trash: [
    "~LibraryApplication SupportStoryboarder",
    "~LibraryPreferencescom.wonderunit.storyboarder.helper.plist",
    "~LibraryPreferencescom.wonderunit.storyboarder.plist",
    "~LibrarySaved Application Statecom.wonderunit.storyboarder.savedState",
  ]
end