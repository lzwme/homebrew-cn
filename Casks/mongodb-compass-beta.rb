cask "mongodb-compass-beta" do
  version "1.42.3-beta.3"
  sha256 "a8e17eecf50550f4a3ea064f44badf8feb2327b2264f718fbca5375e0fcb7415"

  url "https:downloads.mongodb.comcompassbetamongodb-compass-#{version}-darwin-x64.dmg"
  name "MongoDB Compass"
  desc "GUI for MongoDB"
  homepage "https:www.mongodb.comtrydownloadcompass"

  livecheck do
    url "https:github.commongodb-jscompassreleases?q=prerelease%3Atrue&expanded=true"
    regex(%r{href=["']?[^"' >]*?tag\D*?(\d+(?:\.\d+)+-beta\.\d)[^"' >]*?["' >]}i)
    strategy :page_match
  end

  depends_on macos: ">= :high_sierra"

  app "MongoDB Compass Beta.app"

  zap trash: [
    "~.mongodb",
    "~LibraryApplication SupportMongoDB Compass Beta",
    "~LibraryPreferencescom.mongodb.compass.beta.plist",
    "~LibrarySaved Application Statecom.mongodb.compass.beta.savedState",
  ]
end