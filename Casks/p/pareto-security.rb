cask "pareto-security" do
  version "1.8.14"
  sha256 "927630e553a919f363fa27d57e10b7c98b0987b6c357dae663a9aef644524c65"

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