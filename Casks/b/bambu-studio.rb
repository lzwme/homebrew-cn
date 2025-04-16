cask "bambu-studio" do
  version "02.00.02.57,20250415200919"
  sha256 "6c33a9f117aa0c7795cad287f7ffe9fcc882bdedfcc849bd33908dadf77a14ca"

  url "https:github.combambulabBambuStudioreleasesdownloadv#{version.csv.third || version.csv.first}Bambu_Studio_mac-v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.combambulabBambuStudio"
  name "Bambu Studio"
  desc "3D model slicing software for 3D printers, maintained by Bambu Lab"
  homepage "https:bambulab.comendownloadstudio"

  livecheck do
    url :url
    regex(%r{\D*(\d+(?:\.\d+)+[^]*?)Bambu[._-]Studio(?:[._-]mac)?[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        (match[2] == match[1]) ? "#{match[2]},#{match[3]}" : "#{match[2]},#{match[3]},#{match[1]}"
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