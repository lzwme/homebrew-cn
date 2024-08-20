cask "ao" do
  version "6.9.0"
  sha256 "c69522f78e82476540637fd3a2ab0c9de1e911530a1eb88c9cf757e933debe0e"

  url "https:github.comklaussinaniaoreleasesdownloadv#{version}Ao-#{version}.dmg"
  name "Ao"
  desc "Elegant Microsoft To-Do desktop app"
  homepage "https:github.comklaussinaniao"

  app "Ao.app"

  caveats do
    requires_rosetta
  end
end