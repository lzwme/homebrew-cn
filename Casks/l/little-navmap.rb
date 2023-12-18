cask "little-navmap" do
  version "2.8.12"
  sha256 "9bba91375d205326ca3cd06814d68958683adde24087b7afb4476bb811db4d66"

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