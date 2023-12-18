cask "insomnia-alpha" do
  version "8.4.0-beta.0"
  sha256 "89eb1d0db403e5303f08eea8a5f00f35f9c70cbc56d89658bba329b765614451"

  url "https:github.comKonginsomniareleasesdownloadcore%40#{version}Insomnia.Core-#{version}.dmg",
      verified: "github.comKonginsomnia"
  name "Insomnia"
  desc "HTTP and GraphQL Client"
  homepage "https:insomnia.rest"

  livecheck do
    url :url
    regex(^core@v?(\d+(?:\.\d+)+[._-](?:alpha|beta|rc)[._-]?\d*)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true
  conflicts_with cask: "insomnia"
  depends_on macos: ">= :catalina"

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