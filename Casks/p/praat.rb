cask "praat" do
  version "6.4.08,6408"
  sha256 "327503c216b01c3b46466635d2a1c119c9e6fedd20fa6944a0cfd36a0447b91b"

  url "https:github.compraatpraatreleasesdownloadv#{version.csv.first}praat#{version.csv.second}_mac.dmg",
      verified: "github.compraatpraat"
  name "Praat"
  desc "Doing phonetics by computer"
  homepage "https:www.fon.hum.uva.nlpraat"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)praat(\d+)[._-]mac\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  app "Praat.app"
  binary "#{appdir}Praat.appContentsMacOSPraat", target: "praat"

  zap trash: [
    "~LibraryPreferencesPraat Prefs",
    "~LibrarySaved Application Stateorg.praat.Praat.savedState",
  ]
end