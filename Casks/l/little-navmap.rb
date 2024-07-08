cask "little-navmap" do
  version "3.0.8"
  sha256 "d9a928905d9556daf3203fab8b1909173162b75fe900b8f3a9b2c123414243f9"

  url "https:github.comalbar965littlenavmapreleasesdownloadv#{version}LittleNavmap-macOS-#{version}.zip",
      verified: "github.comalbar965littlenavmap"
  name "Little Navmap"
  desc "Flight planning and navigation and airport search and information system"
  homepage "https:albar965.github.iolittlenavmap.html"

  app "Little Navconnect.app"
  app "Little Navmap.app"

  zap trash: [
    "~.configABarthel",
    "~LibrarySaved Application Statecom.yourcompany.littlenavmap.savedState",
  ]

  caveats do
    requires_rosetta
    <<~EOS
      "The X-Plane plugin will be at #{staged_path} after installation."
    EOS
  end
end