cask "little-navmap" do
  version "3.0.5"
  sha256 "531b36abb3284b27700da627f305bf26b9aae0f93ab7a7d67af5926669c9a1d7"

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