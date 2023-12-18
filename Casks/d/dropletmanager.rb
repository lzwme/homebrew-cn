cask "dropletmanager" do
  version "0.5.0"
  sha256 "ed8011cef55f3bcdde4e7e7e331775808e4701fc41acc3191d3e4d80f8ab8335"

  url "https:github.comdeivuhDODropletManager-OSXreleasesdownloadv#{version}DropletManager.v#{version}.zip"
  name "DigitalOcean Droplets Manager"
  desc "Digital Ocean droplet manager"
  homepage "https:github.comdeivuhDODropletManager-OSX"

  app "DropletManager.app"
end