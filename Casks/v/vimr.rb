cask "vimr" do
  version "0.46.1,20240114.181346"
  sha256 "33aabbe736045f9901e89cef3fde7d8a758f39efca039ba7873c7961b79ee53a"

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