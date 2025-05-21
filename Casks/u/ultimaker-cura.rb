cask "ultimaker-cura" do
  arch arm: "ARM64", intel: "X64"

  version "5.10.0"
  sha256 arm:   "57138ede1cbca89ceb403aaf2efc2f6c2162112b3eee42fe54e7284401decdfc",
         intel: "c636e25eac8071db213d66addbd4d214ecfad4a773d83b1f1fefade8f3cdb8d0"

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