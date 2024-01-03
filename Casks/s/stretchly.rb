cask "stretchly" do
  arch arm: "-arm64"

  version "1.15.1"
  sha256 arm:   "d08038378687ff109d75e4a67ca83cca9b096256d2345986ce40b93e5ee7f805",
         intel: "cdb9e9c186262539aa1acf049491a1a3ccd12e9732245fef94d7f9e282198218"

  url "https:github.comhovancikstretchlyreleasesdownloadv#{version}stretchly-#{version}#{arch}.dmg",
      verified: "github.comhovancikstretchly"
  name "Stretchly"
  desc "Break time reminder app"
  homepage "https:hovancik.netstretchly"

  depends_on macos: ">= :catalina"

  app "Stretchly.app"

  zap trash: [
    "~LibraryApplication SupportStretchly",
    "~LibraryLogsStretchly",
    "~LibraryPreferencesnet.hovancik.stretchly.plist",
  ]

  caveats <<~EOS
    This application is not signed. For details see:

    https:github.comhovancikstretchly#application-signing
  EOS
end