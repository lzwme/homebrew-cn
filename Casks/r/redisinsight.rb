cask "redisinsight" do
  arch arm: "arm64", intel: "x64"

  version "2.50.0"
  sha256 :no_check

  url "https:s3.amazonaws.comredisinsight.downloadpubliclatestRedis-Insight-mac-#{arch}.dmg",
      verified: "s3.amazonaws.comredisinsight.download"
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