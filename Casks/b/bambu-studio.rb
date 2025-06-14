cask "bambu-studio" do
  version "02.01.00.59,20250530092153"
  sha256 "31aa8fe0f8d944f15062e32e6790103ca9497a12459356e045fcb7b87aa87126"

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

  no_autobump! because: :requires_manual_review

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