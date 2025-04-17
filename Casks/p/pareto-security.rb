cask "pareto-security" do
  version "1.8.11"
  sha256 "e942d41a0833912d56b3d4969e0f2729d07deec557e3e1b17c91d1c37d0a7ec8"

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