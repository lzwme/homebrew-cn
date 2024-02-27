cask "praat" do
  version "6.4.06,6406"
  sha256 "c5269de8520fe001d288c489b1852366ea778d2315fd6e61f52ade0dcc1b9ba2"

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