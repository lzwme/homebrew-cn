cask "gb-studio" do
  arch arm: "apple-silicon", intel: "intel"

  version "4.0.0"
  sha256 arm:   "c78df6f5ee1759364e6ca5c0c57f0f6fbdc4627655aadc560a75bc77f70f5074",
         intel: "f289eda2a9cfa9ff5f39e8bc615d7e41be97935b6b8a414095adc4f014895dbb"

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