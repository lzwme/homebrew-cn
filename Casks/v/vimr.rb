cask "vimr" do
  version "0.47.3,20240616.090032"
  sha256 "4c2a77265c5358d518a7180bc6ce4805345ed4f8c1115f7bf0bf84c6c836f72e"

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