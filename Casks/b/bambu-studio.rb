cask "bambu-studio" do
  version "01.09.03.50,20240621095059,01.09.03.50"
  sha256 "dd1f70671d520a3d0999774272c34d08b249d7ad325c23652b1524852d4b5d15"

  url "https:github.combambulabBambuStudioreleasesdownloadv#{version.csv.third || version.csv.first}Bambu_Studio_mac-v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.combambulabBambuStudio"
  name "Bambu Studio"
  desc "3D model slicing software for 3D printers, maintained by Bambu Lab"
  homepage "https:bambulab.comendownloadstudio"

  livecheck do
    url :homepage
    regex(%r{href=.*v?(\d+(?:\.\d+)+)Bambu[._-]Studio[._-]mac[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.dmg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        if match[2] == match[0]
          "#{match[1]},#{match[2]}"
        else
          "#{match[1]},#{match[2]},#{match[0]}"
        end
      end
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