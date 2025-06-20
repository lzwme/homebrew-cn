cask "goofy" do
  version "3.5.4"
  sha256 "a41bd37f7ba1f0cd88cd5241ffcd22ea9087320b9cfa525298565aea9fba121b"

  url "https:github.comdanielbuechelegoofyreleasesdownloadv#{version}Goofy-#{version}.dmg"
  name "Goofy"
  desc "Desktop client for Facebook Messenger"
  homepage "https:github.comdanielbuechelegoofy"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Goofy.app"

  zap trash: [
    "~LibraryApplication Supportgoofy-core",
    "~LibraryCachescc.buechele.Goofy",
    "~LibraryCachescc.buechele.Goofy.ShipIt",
    "~LibraryPreferencescc.buechele.Goofy.helper.plist",
    "~LibraryPreferencescc.buechele.Goofy.plist",
    "~LibrarySaved Application Statecc.buechele.Goofy.savedState",
  ]

  caveats do
    requires_rosetta
  end
end