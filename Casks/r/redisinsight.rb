cask "redisinsight" do
  arch arm: "arm64", intel: "x64"

  version "2.44.0"
  sha256 :no_check

  url "https:download.redisinsight.redis.comlatestRedisInsight-mac-#{arch}.dmg"
  name "RedisInsight"
  desc "GUI for streamlined Redis application development"
  homepage "https:redis.comredis-enterpriseredis-insight"

  # The first-party site doesn't publish public version information (the page
  # requires users to submit contact information to download files). We check
  # GitHub releases as a best guess of when a new version is released.
  livecheck do
    url "https:github.comRedisInsightRedisInsight"
    strategy :github_latest
  end

  auto_updates true

  app "RedisInsight.app"

  zap trash: [
    "~LibraryPreferencesorg.RedisLabs.RedisInsight-V#{version.major}.plist",
    "~LibrarySaved Application Stateorg.RedisLabs.RedisInsight-V#{version.major}.savedState",
  ]
end