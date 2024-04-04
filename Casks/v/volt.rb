cask "volt" do
  version "0.96"
  sha256 arm:   "f7c0eb75c4a7e93abc3b8cc248e31db5cdb1871d0936162e183f9f3e684af8a4",
         intel: "7a52cb3dd08b82f4ae48777fa6625bc79c798a91714cbc0a5c0c1ab069c746bc"

  on_arm do
    url "https:github.comvoltappvoltreleasesdownload#{version}volt_macos_arm64.zip",
        verified: "github.comvoltappvolt"
  end
  on_intel do
    url "https:github.comvoltappvoltreleasesdownload#{version}Volt.dmg",
        verified: "github.comvoltappvolt"
  end

  name "Volt"
  desc "Client for Slack, Discord, Skype, Gmail, Twitter, Facebook, and more"
  homepage "https:volt-app.com"

  app "Volt.app"

  zap trash: [
    "~.volt",
    "~LibraryCachesVolt",
    "~LibraryHTTPStoragesVolt.binarycookies",
    "~LibraryWebKitVolt",
  ]
end