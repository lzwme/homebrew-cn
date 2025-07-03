cask "yaak@beta" do
  arch arm: "aarch64", intel: "x64"

  version "2025.5.0-beta.3"
  sha256 arm:   "26ce8a322961f7e851ece9298b25e293233e504e8379b446e7f6ba8dc23715b2",
         intel: "9b515726d98deb6db6fc38c2e72f65b5d6756c1180ca21f2b74b415a81490d15"

  url "https:github.commountain-loopyaakreleasesdownloadv#{version}Yaak_#{version}_#{arch}.dmg",
      verified: "github.commountain-loopyaak"
  name "Yaak Beta"
  desc "REST, GraphQL and gRPC client"
  homepage "https:yaak.app"

  # Beta releases of the app use the same update URL as stable releases but an
  # `x-update-mode: beta` request header is used to retrieve beta updates
  # instead. livecheck doesn't support setting arbitrary headers in `livecheck`
  # blocks yet, so we check GitHub for now. It's necessary to check releases
  # instead of Git tags, as there can be a notable gap between tag and release.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:[._-](?:beta|rc)[._-]\d+)?)$i)
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
  conflicts_with cask: "yaak"
  depends_on macos: ">= :ventura"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end