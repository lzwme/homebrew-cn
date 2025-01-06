cask "gb-studio" do
  arch arm: "apple-silicon", intel: "intel"

  version "4.1.3"
  sha256 arm:   "95712c8ec4bcf940fd6058536f278197fd3fe2e0471c297bcf76afc442aacca6",
         intel: "8111b041246b5f5b81b1e3ab1f33304715a5a51400be91dc04d6d00d5dc2c935"

  url "https:github.comchrismaltbygb-studioreleasesdownloadv#{version}gb-studio-mac-#{arch}.zip",
      verified: "github.comchrismaltbygb-studio"
  name "GB Studio"
  desc "Drag and drop retro game creator"
  homepage "https:www.gbstudio.dev"

  depends_on macos: ">= :high_sierra"

  app "GB Studio.app"

  zap trash: [
    "~LibraryApplication SupportGB Studio",
    "~LibraryPreferencesdev.gbstudio.gbstudio.plist",
    "~LibrarySaved Application Statedev.gbstudio.gbstudio.savedState",
  ]
end