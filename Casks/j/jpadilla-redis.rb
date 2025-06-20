cask "jpadilla-redis" do
  version "4.0.2-build.1"
  sha256 "1a4c0c82739a2bddbd5fa78f598cd28dd2c348467a12cb8de6687114f2bad4da"

  url "https:github.comjpadillaredisappreleasesdownload#{version}Redis.zip",
      verified: "github.comjpadillaredisapp"
  name "Redis"
  desc "App wrapper for Redis"
  homepage "https:jpadilla.github.ioredisapp"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-04-15", because: :unmaintained

  app "Redis.app"

  zap trash: [
    "~LibraryCachesio.blimp.Redis",
    "~LibraryPreferencesio.blimp.Redis.plist",
  ]

  caveats do
    requires_rosetta
  end
end