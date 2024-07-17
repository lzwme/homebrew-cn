cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.43.5-beta.1"
  sha256 arm:   "148b1ad230ad8b03807da61596459d6ca245e8d762c2aa3e7ea39d9717c20e15",
         intel: "eb9628ea032fbfb3bcb8f4f117cbacf115233e73e5e0ad07c3bcd3e998857b20"

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