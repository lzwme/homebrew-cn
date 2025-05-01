cask "insomnia@alpha" do
  version "11.1.0-beta.4"
  sha256 "429bbf72039fa3e08e6565449f7d2053a49d5acba0379510e46e308945c9e799"

  url "https:github.comKonginsomniareleasesdownloadcore%40#{version}Insomnia.Core-#{version}.dmg",
      verified: "github.comKonginsomnia"
  name "Insomnia"
  desc "HTTP and GraphQL Client"
  homepage "https:insomnia.rest"

  livecheck do
    url "https:updates.insomnia.restbuildscheckmac?v=#{version.major}.0.0#{"-beta.0" if version.split("-")&.second}&app=com.insomnia.app&channel=beta"
    strategy :json do |json|
      json["name"]
    end
  end

  auto_updates true
  conflicts_with cask: "insomnia"
  depends_on macos: ">= :big_sur"

  app "Insomnia.app"

  zap trash: [
    "~LibraryApplication SupportInsomnia",
    "~LibraryCachescom.insomnia.app",
    "~LibraryCachescom.insomnia.app.ShipIt",
    "~LibraryCookiescom.insomnia.app.binarycookies",
    "~LibraryPreferencesByHostcom.insomnia.app.ShipIt.*.plist",
    "~LibraryPreferencescom.insomnia.app.helper.plist",
    "~LibraryPreferencescom.insomnia.app.plist",
    "~LibrarySaved Application Statecom.insomnia.app.savedState",
  ]
end