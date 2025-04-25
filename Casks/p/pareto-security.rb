cask "pareto-security" do
  version "1.8.12"
  sha256 "39585a82be96f44088c3dddfe6d769f4a1f6f8942561908c293e76a24c6fab8b"

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