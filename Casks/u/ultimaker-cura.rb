cask "ultimaker-cura" do
  arch arm: "ARM64", intel: "X64"

  on_arm do
    version "5.9.0"
    sha256 "55ba3809a33f8e882f7a2fe608994190bcfbec6d10e53345ee2f2fabd02d80eb"
  end
  on_intel do
    version "5.9.0"
    sha256 "beeb3a32381d48fea8d5c27b737acf008b44363b7c75e16b9bed98379dc9de84"
  end

  url "https:github.comUltimakerCurareleasesdownload#{version.csv.second || version.csv.first}UltiMaker-Cura-#{version.csv.first}-macos-#{arch}.dmg",
      verified: "github.comUltimakerCura"
  name "UltiMaker Cura"
  name "Cura"
  desc "3D printer and slicing GUI"
  homepage "https:ultimaker.comsoftwareultimaker-cura"

  livecheck do
    url :url
    regex(^(\d+(?:\.\d+)+)i)
    strategy :github_latest do |json, regex|
      tag = json["tag_name"]&.sub(^\D+, "")
      match = tag&.match(regex)
      next if match.blank?

      (match[1] == tag) ? match[1] : "#{match[1]},#{tag}"
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