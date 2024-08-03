cask "ultimaker-cura" do
  arch arm: "ARM64", intel: "X64"

  on_arm do
    version "5.8.0,5.8.0"
    sha256 "c56d23dc6f218057d0bf41e333c549bf3069bce40eb22d0d3d4d987d7e33334c"
  end
  on_intel do
    version "5.8.0,5.8.0"
    sha256 "547c99b042565be1149044520de17fd68f29984e5254776ab7cbd89abb156995"
  end

  url "https:github.comUltimakerCurareleasesdownload#{version.csv.second}UltiMaker-Cura-#{version.csv.first}-macos-#{arch}.dmg",
      verified: "github.comUltimakerCura"
  name "UltiMaker Cura"
  name "Cura"
  desc "3D printer and slicing GUI"
  homepage "https:ultimaker.comsoftwareultimaker-cura"

  livecheck do
    url :url
    regex(^(\d+(?:\.\d+)+)i)
    strategy :github_latest do |item, regex|
      version = item["tag_name"][regex, 1]
      next if version.blank?

      "#{version},#{item["tag_name"]}"
    end
  end

  app "UltiMaker Cura.app"

  uninstall quit: "nl.ultimaker.cura.dmg"

  zap trash: [
    "~.cura",
    "~LibraryApplication Supportcura",
    "~LibraryCachesUltimaker B.V.Ultimaker-Cura",
    "~LibraryLogscura",
    "~LibraryPreferencesnl.ultimaker.cura.dmg.plist",
    "~LibraryPreferencesnl.ultimaker.cura.plist",
    "~LibrarySaved Application Statenl.ultimaker.cura.dmg.savedState",
  ]
end