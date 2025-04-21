cask "little-navmap" do
  version "3.0.17"
  sha256 "8c1faacd96932bc2f6b05cb9fef74826bb8804010a6efe7768831be260afdfd2"

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