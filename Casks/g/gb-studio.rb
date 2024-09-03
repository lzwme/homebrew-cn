cask "gb-studio" do
  arch arm: "apple-silicon", intel: "intel"

  version "4.1.0"
  sha256 arm:   "68c42d59cfa3bf8868a13c90fa793a8b3fb6a2d17a0783d8f0482967c5201905",
         intel: "19c1c296ab54a99c2dab9f5480ed4be7b78c785a98219f2a1a166301a7550a0b"

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