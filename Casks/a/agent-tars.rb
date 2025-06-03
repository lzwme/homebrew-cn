cask "agent-tars" do
  version "1.0.0-alpha.9"
  sha256 "3e104fcf21a52025c024aa674b5d2931454f884d710bcfb3d393fddd7a7c815c"

  url "https:github.combytedanceUI-TARS-desktopreleasesdownloadAgent-TARS-v#{version}Agent.TARS-#{version}-universal.dmg"
  name "Agent TARS"
  desc "Multimodal AI agent for GUI interaction"
  homepage "https:github.combytedanceUI-TARS-desktop"

  # The upstream repository creates releases for more than just Agent TARS, so
  # we have to check multiple releases because the "latest" release may be for
  # something different.
  livecheck do
    url :url
    regex(^Agent[._-]TARS[._-]v?(\d+(?:\.\d+)+(?:[._-](?:alpha|beta)[._-]?\d+)?)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        # TODO: Reinstate pre-release skipping when the cask is updated to a
        # stable release.
        next if release["draft"] # || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Agent TARS.app"

  uninstall quit: "com.bytedance.agenttars"

  zap trash: [
    "~LibraryApplication Supportagent-tars",
    "~LibraryLogsagent-tars",
  ]
end