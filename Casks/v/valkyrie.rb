cask "valkyrie" do
  version "2.6.0"
  sha256 "0aaa7435012fdae6f39b88f7cbbc9a179c992acd068d4ae6539fd973e0aa17a6"

  url "https:github.comNPBrucevalkyriereleasesdownloadrelease#{version.major_minor}#{version}valkyrie-macos-#{version}.tar.gz",
      verified: "github.comNPBrucevalkyrie"
  name "Valkyrie"
  desc "Game Master for Fantasy Flight board games"
  homepage "https:npbruce.github.iovalkyrie"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

  app "Valkyrie.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterValkyrie_*.plist",
    "~LibraryPreferencesunity.NA.Valkyrie.plist",
    "~LibrarySaved Application Stateunity.NA.Valkyrie.savedState",
  ]

  caveats do
    requires_rosetta
  end
end