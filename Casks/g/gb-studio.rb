cask "gb-studio" do
  arch arm: "apple-silicon", intel: "intel"

  version "4.1.1"
  sha256 arm:   "24eb69459b930daf4bc3fbf2a9eeafb9c10c367da51d9e5fdbd9df989690e990",
         intel: "7254fafec357562a284bd6fc7d1c61d13f44ea475539c0cc570ed795427798c9"

  url "https:github.comchrismaltbygb-studioreleasesdownloadv#{version}gb-studio-mac-#{arch}.zip",
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