cask "5ire" do
  arch arm: "-arm64"

  version "0.12.1"
  sha256 arm:   "9e07135a765498a3fa1596d00ceff4c4ce83fd74a6ced88b5645b355f47d2e1f",
         intel: "3dfbf76d8ba9e71ced5d34d8be3bdb21628e52971757a3948d6dcda21e34f573"

  url "https:github.comnanbingxyz5irereleasesdownloadv#{version}5ire-#{version}#{arch}.dmg",
      verified: "github.comnanbingxyz5ire"
  name "5ire"
  desc "AI assistant and MCP client"
  homepage "https:5ire.app"

  depends_on macos: ">= :catalina"

  app "5ire.app"

  zap trash: [
    "~LibraryApplication Support5ire",
    "~LibraryLogs5ire",
    "~LibraryPreferencescom.5ire.5ire.plist",
  ]
end