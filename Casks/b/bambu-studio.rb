cask "bambu-studio" do
  version "01.09.04.60,20240826172441,01.09.04.60"
  sha256 "ab358ac05b2a1972741b395f1a4655ff8dd2aa27348a215dd1ae95b82286b0f6"

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