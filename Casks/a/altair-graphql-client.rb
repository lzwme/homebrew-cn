cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.2.4"
  sha256 arm:   "0f995d5c512198aeab7e6ecf0ef73a4741892796679fafe59b03d96ea8928b47",
         intel: "50ee0bd47250df7b1744bb76bd91d162389b0fba0de7316ba19d71c55e32122d"

  url "https:github.comimolorhealtairreleasesdownloadv#{version}altair_#{version}_#{arch}_mac.zip",
      verified: "github.comimolorhealtair"
  name "Altair GraphQL Client"
  desc "GraphQL client"
  homepage "https:altair.sirmuel.design"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Altair GraphQL Client.app"

  zap trash: [
    "~LibraryApplication Supportaltair",
    "~LibraryPreferencescom.electron.altair.helper.plist",
    "~LibraryPreferencescom.electron.altair.plist",
    "~LibrarySaved Application Statecom.electron.altair.savedState",
  ]
end