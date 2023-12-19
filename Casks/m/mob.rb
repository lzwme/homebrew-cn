cask "mob" do
  version "0.2.2"
  sha256 "a70d66d92310737d9599215d558670a45265795be0be980934a91e9880eb4a73"

  url "https:github.comzenghongtuMobreleasesdownloadv#{version}Mob-#{version}-mac.dmg"
  name "Mob"
  homepage "https:github.comzenghongtuMob"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Mob.app"

  zap trash: "~LibraryApplication Supportmob"
end