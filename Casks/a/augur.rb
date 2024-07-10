cask "augur" do
  version "1.16.11"
  sha256 "127a57ed9e3e0b2bd0451f0b097d5998f3e59acb7c4b9d424166f460a1776411"

  url "https:github.comAugurProjectaugur-appreleasesdownloadv#{version}mac-Augur-#{version}.dmg"
  name "Augur"
  desc "App that bundles Augur UI and Augur Node together and deploys them locally"
  homepage "https:github.comAugurProjectaugur-app"

  app "augur.app"

  caveats do
    requires_rosetta
  end
end