cask "osu@tachyon" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2026.428.0-tachyon"
  sha256 arm:   "522708e8ddc6e8eebda66b22a70a7c362ce67d566f12869fc43aee30f6a40d21",
         intel: "498ace7b80750c322a297d703d3774f8511a8a191690c938f3eeff82377c77a7"

  url "https://ghfast.top/https://github.com/ppy/osu/releases/download/#{version}/osu.app.#{arch}.zip"
  name "osu! (tachyon)"
  desc "Rhythm game"
  homepage "https://github.com/ppy/osu/"

  # There can be a notable gap between tag and release, so it's necessary to
  # check releases instead of Git tags. Tachyon releases are marked as
  # "pre-release" on GitHub, so we have to use the `GithubReleases` strategy.
  livecheck do
    url :url
    regex(/^v?((\d+(?:\.\d+)+)(?:-\w+)?)$/i)
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
  conflicts_with cask: "osu"
  depends_on :macos

  app "osu!.app"

  zap trash: [
    "~/.local/share/osu",
    "~/Library/Saved Application State/sh.ppy.osu.lazer.savedState",
  ]
end