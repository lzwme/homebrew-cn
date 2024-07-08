cask "youll-never-take-me-alive" do
  version "1.0.2"
  sha256 "6d89162762e4e952bec046943c094f37c06b89795d477fff46006362bc6c282a"

  url "https:github.comiSECPartnersyontma-macreleasesdownload#{version}yontma-#{version}.dmg"
  name "You'll Never Take Me Alive!"
  name "YoNTMA"
  desc "Utility to enhance the protection of encrypted data"
  homepage "https:github.comiSECPartnersyontma-mac"

  app "You'll Never Take Me Alive!.app"

  caveats do
    requires_rosetta
  end
end