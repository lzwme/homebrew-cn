cask "praat" do
  version "6.4.18,6418"
  sha256 "187289cba48d7e324397eb231dfbde5faf6540f6eea0331792df41f0040c8c27"

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