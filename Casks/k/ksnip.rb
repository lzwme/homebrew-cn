cask "ksnip" do
  version "1.10.1"
  sha256 "a029364951e0377f3e625a7af70313d1266145a62185e8e127286b5564b11e08"

  url "https:github.comksnipksnipreleasesdownloadv#{version}ksnip-#{version}.dmg"
  name "ksnip"
  desc "Screenshot and annotation tool"
  homepage "https:github.comksnipksnip"

  app "ksnip.app"

  zap trash: [
    "~LibraryPreferencesorg.ksnip.*.plist",
    "~LibrarySaved Application Stateorg.ksnip.ksnip.savedState",
  ]

  caveats do
    requires_rosetta
  end
end