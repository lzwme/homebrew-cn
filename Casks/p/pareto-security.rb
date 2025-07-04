cask "pareto-security" do
  version "1.9.4"
  sha256 "f15c5a5aed80a9add5abcbf104cd75fd61e9525c1b45bc56ef09fd1b37782993"

  url "https:github.comParetoSecuritypareto-macreleasesdownload#{version}ParetoSecurity.dmg",
      verified: "github.comParetoSecuritypareto-mac"
  name "Pareto Security"
  desc "Security checklist app"
  homepage "https:paretosecurity.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Pareto Security.app"

  zap trash: [
    "~LibraryCachesniteo.co.Pareto",
    "~LibraryHTTPStoragesniteo.co.Pareto",
    "~LibraryPreferencesniteo.co.Pareto.plist",
  ]
end