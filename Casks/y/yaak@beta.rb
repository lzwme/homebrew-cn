cask "yaak@beta" do
  arch arm: "aarch64", intel: "x64"

  version "2025.4.0"
  sha256 arm:   "02f4c23e1988704401c8df867dd7eb197ef40fb013107e63001295c04f621b16",
         intel: "993549a739beaf463c9a9902d157a45162aebcc6df7728ec92405a83bb0dfd7b"

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