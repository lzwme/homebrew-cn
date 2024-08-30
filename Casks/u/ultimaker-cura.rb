cask "ultimaker-cura" do
  arch arm: "ARM64", intel: "X64"

  on_arm do
    version "5.8.1,5.8.1"
    sha256 "208c84df8a7d2f0e8ae5caba482b94f753f20a08fe48a0bdcb182bf612042cf1"
  end
  on_intel do
    version "5.8.1,5.8.1"
    sha256 "cd01ea4fedddba374f8b11d8247f4a362b4a3e20143241cec18fce3139276f4a"
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