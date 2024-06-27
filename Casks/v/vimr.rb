cask "vimr" do
  version "0.47.4,20240626.190016"
  sha256 "6e43b46040f4b50918492cfe8bb62672a5115cdf3280ed526891a4bee53d9b81"

  url "https:github.comqvacuavimrreleasesdownloadv#{version.csv.first}-#{version.csv.second}VimR-v#{version.csv.first}.tar.bz2",
      verified: "github.comqvacuavimr"
  name "VimR"
  desc "GUI for the Neovim text editor"
  homepage "http:vimr.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[._-](\d+(?:\.\d+)+)$i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "VimR.app"
  binary "#{appdir}VimR.appContentsResourcesvimr"

  zap trash: [
    "~LibraryCachescom.qvacua.VimR",
    "~LibraryPreferencescom.qvacua.VimR.menuitems.plist",
    "~LibraryPreferencescom.qvacua.VimR.plist",
    "~LibrarySaved Application Statecom.qvacua.VimR.savedState",
    "~LibraryWebKitcom.qvacua.VimR",
  ]
end