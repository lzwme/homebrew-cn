cask "yaak@beta" do
  arch arm: "aarch64", intel: "x64"

  version "2025.2.0-beta.7"
  sha256 arm:   "05276a598d980222b15a30155cdde80e8971f779c0fb01e0e37bc4a7139c1e7c",
         intel: "2a8282548d6e6a0088478618d76e357c6802ab334c5b78e9d47f45934b1440d1"

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