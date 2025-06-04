cask "ultimaker-cura" do
  arch arm: "ARM64", intel: "X64"

  version "5.10.1"
  sha256 arm:   "6fdcbec9a6803a419abd89171a3740debb90dc0133a60e36f41850e6891d0060",
         intel: "6ce363910529160f4cb68a58b529d62b5f66bed164fba5f91a4111095e48ba56"

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

  depends_on macos: ">= :high_sierra"

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