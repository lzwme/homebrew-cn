cask "rodeo" do
  version "2.5.2"
  sha256 "9e96d1966cc2a5159c4079312e30c1c20ad834fa766bc92dac938fb944c79d0d"

  url "https:github.comyhatrodeoreleasesdownloadv#{version}Rodeo-#{version}.dmg"
  name "Rodeo"
  desc "Data science IDE for Python"
  homepage "https:github.comyhatrodeo"

  app "Rodeo.app"

  caveats do
    requires_rosetta
  end
end