cask "yellowdot" do
  on_monterey :or_older do
    version "1"
    sha256 "6ef028d450c3a102f0031e70bffe2c22dc8363661bc463673130a01b0e186fde"

    url "https:github.comFuzzyIdeasYellowDotreleasesdownloadv#{version}YellowDot.zip",
        verified: "github.comFuzzyIdeasYellowDot"

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "2.5"
    sha256 "ee5263c3858cb899484d0afc7bf502904015fff9ea7e8a6daa19116f4a308fba"

    url "https:github.comFuzzyIdeasYellowDotreleasesdownloadv#{version}YellowDot-#{version}.dmg",
        verified: "github.comFuzzyIdeasYellowDot"
  end

  name "Yellow Dot"
  desc "Hides privacy indicators"
  homepage "https:lowtechguys.comyellowdot"

  depends_on macos: ">= :big_sur"

  app "YellowDot.app"

  uninstall quit:       "com.lowtechguys.YellowDot",
            login_item: "YellowDot"

  zap trash: "~LibraryPreferencescom.lowtechguys.YellowDot.plist"
end