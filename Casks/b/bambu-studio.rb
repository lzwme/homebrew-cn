cask "bambu-studio" do
  version "01.08.03.89,20240109202633"
  sha256 "72f8a9242160aae4fc0e51eadc8e1ec341975fe7504fe6da90783e02a4dc1598"

  url "https:github.combambulabBambuStudioreleasesdownloadv#{version.csv.first}Bambu_Studio_mac-v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.combambulabBambuStudio"
  name "Bambu Studio"
  desc "3D model slicing software for 3D printers, maintained by Bambu Lab"
  homepage "https:bambulab.comendownloadstudio"

  livecheck do
    url :homepage
    regex(href=.*Bambu[._-]Studio[._-]mac[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match.first},#{match.second}" }
    end
  end

  depends_on macos: ">= :catalina"

  app "BambuStudio.app"

  zap trash: [
    "LibraryLogsDiagnosticsReportsBambuStudio*",
    "~LibraryApplication SupportBambuStudio",
    "~LibraryCachescom.bambulab.bambu-studio",
    "~LibraryHTTPStoragescom.bambulab.bambu-studio.binarycookies",
    "~LibraryPreferencescom.bambulab.bambu-studio.plist",
    "~LibrarySaved Application Statecom.bambulab.bambu-studio.savedState",
    "~LibraryWebKitcom.bambulab.bambu-studio",
  ]
end