cask "little-navmap" do
  version "3.0.4"
  sha256 "165e14f4550432131b752b10e25ac993fc8a4269a1bc410d7c9088e3530f4236"

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

  caveats "The X-Plane plugin will be at #{staged_path} after installation."
end