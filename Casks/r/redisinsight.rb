cask "redisinsight" do
  arch arm: "arm64", intel: "x64"

  version "2.48.0"
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
    strategy :git
  end

  auto_updates true

  app "Redis Insight.app"

  zap trash: [
    "~LibraryPreferencesorg.RedisLabs.RedisInsight-V#{version.major}.plist",
    "~LibrarySaved Application Stateorg.RedisLabs.RedisInsight-V#{version.major}.savedState",
  ]
end