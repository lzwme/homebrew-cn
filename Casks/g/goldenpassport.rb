cask "goldenpassport" do
  version "0.1.7"
  sha256 "696a2cd0c6245502727b2cab0f0a2d92c636fca6e4c3c1fbfa289e152cadc46c"

  url "https:github.comstanzhaiGoldenPassportreleasesdownloadv#{version}GoldenPassport.zip"
  name "GoldenPassport"
  desc "Native implementation of Google Authenticator based on Swift3"
  homepage "https:github.comstanzhaiGoldenPassport"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "GoldenPassport.app"

  zap trash: [
    "~LibraryApplication SupportGoldenPassport",
    "~LibraryPreferencessite.stanzhai.GoldenPassport.plist",
  ]
end