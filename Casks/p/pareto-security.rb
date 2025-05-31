cask "pareto-security" do
  version "1.8.16"
  sha256 "c98ab7364074bdf5189d771bb3d65a3c18709d7d143991a8fee39c9b94a485b3"

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