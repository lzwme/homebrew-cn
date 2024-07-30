cask "gb-studio" do
  arch arm: "apple-silicon", intel: "intel"

  version "4.0.2"
  sha256 arm:   "18c6652a15eb2b0c71302343ac8ac294e1bafd9d9cee6db3338016c1211b3e95",
         intel: "9140427d545b369521414c57802bc93849322b74b82b1f5187b9b9dfe9df3e2d"

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