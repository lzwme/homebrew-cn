cask "defold@beta" do
  arch arm: "arm64", intel: "x86_64"

  version "1.9.6"
  sha256 :no_check # required as upstream package is updated in-place

  url "https:github.comdefolddefoldreleasesdownload#{version}-betaDefold-#{arch}-macos.dmg",
      verified: "github.comdefolddefold"
  name "Defold"
  desc "Game engine for development of desktop, mobile and web games"
  homepage "https:defold.com"

  # The `GithubReleases` strategy omits releases marked as pre-release, so we
  # have to use a `strategy` block to work with unstable versions.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[._-]beta$i)
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
  conflicts_with cask: [
    "defold",
    "defold@alpha",
  ]

  app "Defold.app"

  zap trash: [
    "~LibraryApplication SupportDefold",
    "~LibraryCachescom.defold.editor",
    "~LibraryPreferencescom.defold.editor.plist",
    "~LibrarySaved Application Statecom.defold.editor.savedState",
  ]
end