cask "font-league-spartan" do
  version "2.220"
  sha256 "141a96e215554871504dca16be159901bbb0d56f3a84224f39fe472c7ab4ef47"

  url "https:github.comtheleagueofleague-spartanreleasesdownload#{version}LeagueSpartan-#{version}.tar.xz",
      verified: "github.comtheleagueofleague-spartan"
  name "League Spartan"
  desc "Geometric sans-serif revival of ATF’s classic Spartan"
  homepage "https:www.theleagueofmoveabletype.comleague-spartan"

  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-ExtraLight.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-Light.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-Medium.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-Regular.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-SemiBold.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-Bold.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-ExtraBold.otf"
  font "LeagueSpartan-#{version}staticOTFLeagueSpartan-Black.otf"
  font "LeagueSpartan-#{version}variableTTFLeagueSpartan-VF.ttf"

  # No zap stanza required
end