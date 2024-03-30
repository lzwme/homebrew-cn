cask "drata-agent" do
  version "3.6.1"
  sha256 "966a3ad120ef4d46b845b6882859e440e58d75b54a2eb46d5188130975991ede"

  url "https:github.comdrataagent-releasesreleasesdownloadv#{version}Drata-Agent-mac.dmg",
      verified: "github.comdrataagent-releases"
  name "Drata Agent"
  desc "Security audit software"
  homepage "https:drata.com"

  depends_on macos: ">= :high_sierra"

  app "Drata Agent.app"

  zap trash: [
    "~LibraryApplication Supportdrata-agent",
    "~LibraryLogsdrata-agent",
    "~LibraryPreferencescom.drata.agent.plist",
  ]
end