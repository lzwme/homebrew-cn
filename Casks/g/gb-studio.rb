cask "gb-studio" do
  version "3.2.0"
  sha256 "ae43525f08b94b93dc10b3a8593539163858ae13ef657208701213eb5425d426"

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