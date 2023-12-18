cask "valkyrie" do
  version "2.5.7"
  sha256 "e667934e6ee3f27d3f81591b830d2be4513c8997f54f5312be56917c0697ce75"

  url "https:github.comNPBrucevalkyriereleasesdownloadrelease#{version.major_minor}v#{version}valkyrie-macos-#{version}.tar.gz",
      verified: "github.comNPBrucevalkyrie"
  name "Valkyrie"
  desc "Game Master for Fantasy Flight board games"
  homepage "https:npbruce.github.iovalkyrie"

  livecheck do
    url :url
    regex(%r{v(\d+(?:\.\d+)+)$}i)
  end

  app "Valkyrie.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterValkyrie_*.plist",
    "~LibraryPreferencesunity.NA.Valkyrie.plist",
    "~LibrarySaved Application Stateunity.NA.Valkyrie.savedState",
  ]
end