cask "goofy" do
  version "3.5.4"
  sha256 "a41bd37f7ba1f0cd88cd5241ffcd22ea9087320b9cfa525298565aea9fba121b"

  url "https:github.comdanielbuechelegoofyreleasesdownloadv#{version}Goofy-#{version}.dmg",
      verified: "github.comdanielbuechelegoofy"
  name "Goofy"
  desc "Desktop client for Facebook Messenger"
  homepage "https:www.goofyapp.com"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Goofy.app"

  zap trash: [
    "~LibraryApplication Supportgoofy-core",
    "~LibraryCachescc.buechele.Goofy",
    "~LibraryCachescc.buechele.Goofy.ShipIt",
    "~LibraryPreferencescc.buechele.Goofy.helper.plist",
    "~LibraryPreferencescc.buechele.Goofy.plist",
    "~LibrarySaved Application Statecc.buechele.Goofy.savedState",
  ]
end