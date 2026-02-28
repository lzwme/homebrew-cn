cask "block-goose" do
  arch intel: "_intel_mac"

  version "1.26.1"
  sha256 arm:   "1333f48efddfcb0f3af5a81aee90881ebd9401df6c2d70e8ed9cdd815762544c",
         intel: "8a3316455c41b2340a9229fcd76183cebe1da203455a71fe858241506406aa45"

  url "https://ghfast.top/https://github.com/block/goose/releases/download/v#{version}/Goose#{arch}.zip",
      verified: "github.com/block/goose/"
  name "Goose"
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"

  # Some releases don't provide assets for Goose Desktop, so we have to check
  # multiple releases to identify the newest version for the desktop app.
  livecheck do
    url :url
    regex(%r{/v?(\d+(?:\.\d+)+)/Goose#{arch}\.zip}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  depends_on macos: ">= :monterey"

  app "Goose.app"

  zap trash: "~/Library/Application Support/Goose"
end