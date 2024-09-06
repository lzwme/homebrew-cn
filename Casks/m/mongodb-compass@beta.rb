cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.44.2-beta.0"
  sha256 arm:   "8ecce968d03b1f477694958b51f26b98a0c4e7558f29ab61eb1caf5e409dc36a",
         intel: "a42268351574df5ed149e554dd0b6194af04471c8d0e4ad2695cc563fe99c26f"

  url "https:downloads.mongodb.comcompassbetamongodb-compass-#{version}-darwin-#{arch}.dmg"
  name "MongoDB Compass"
  desc "GUI for MongoDB"
  homepage "https:www.mongodb.comtrydownloadcompass"

  livecheck do
    url "https:github.commongodb-jscompassreleases?q=prerelease%3Atrue&expanded=true"
    regex(%r{href=["']?[^"' >]*?tag\D*?(\d+(?:\.\d+)+-beta\.\d)[^"' >]*?["' >]}i)
    strategy :page_match
  end

  depends_on macos: ">= :catalina"

  app "MongoDB Compass Beta.app"

  zap trash: [
    "~.mongodb",
    "~LibraryApplication SupportMongoDB Compass Beta",
    "~LibraryPreferencescom.mongodb.compass.beta.plist",
    "~LibrarySaved Application Statecom.mongodb.compass.beta.savedState",
  ]
end