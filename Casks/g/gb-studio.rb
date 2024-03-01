cask "gb-studio" do
  version "3.2.1"
  sha256 "79f041367b6d68cd87851c7b3e810acb45f9357038c285e6b7e071cacbff0f3c"

  url "https:github.comchrismaltbygb-studioreleasesdownloadv#{version}gb-studio-mac.zip",
      verified: "github.comchrismaltbygb-studio"
  name "GB Studio"
  desc "Drag and drop retro game creator"
  homepage "https:www.gbstudio.dev"

  app "GB Studio.app"

  zap trash: [
    "~LibraryApplication SupportGB Studio",
    "~LibraryPreferencesdev.gbstudio.gbstudio.plist",
    "~LibrarySaved Application Statedev.gbstudio.gbstudio.savedState",
  ]
end