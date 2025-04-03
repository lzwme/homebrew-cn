cask "espanso" do
  arch arm: "M1", intel: "Intel"

  version "2.2.1"
  sha256 arm:   "419687d4d954630c8690e315eb7830b28f03b95521d720fc2bd960e084d49993",
         intel: "369ad7eb9a30015a3836012970acd15b3b06c6f67349a89ced6bb3ae9c3f2d20"

  url "https:github.comespansoespansoreleasesdownloadv#{version}Espanso-Mac-#{arch}.zip",
      verified: "github.comespansoespanso"
  name "Espanso"
  desc "Cross-platform Text Expander written in Rust"
  homepage "https:espanso.org"

  # Upstream may not mark unstable releases like `1.2.3-beta` as pre-release
  # on GitHub, so they can end up as the "latest" release. They also tag
  # versions that may not end up with a release and some releases use a stable
  # version format but are marked as pre-release, so we can't rely on Git tags.
  # This checks the first-party website's Installation page, which links to
  # release files on GitHub.
  livecheck do
    url "https:espanso.orginstall"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)Espanso-Mac-#{arch}\.zip}i)
  end

  app "Espanso.app"
  binary "#{appdir}Espanso.appContentsMacOSespanso"

  zap trash: [
    "~LibraryApplication Supportespanso",
    "~LibraryCachesespanso",
    "~LibraryLaunchAgentscom.federicoterzi.espanso.plist",
    "~LibraryPreferencescom.federicoterzi.espanso.plist",
    "~LibraryPreferencesespanso",
    "~LibraryPreferencesespanso.plist",
    "~LibrarySaved Application Statecom.federicoterzi.espanso.savedState",
  ]
end