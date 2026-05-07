cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.43"
  sha256 arm:          "779bc5858eb97e6c0749c99ec8bcd99aafce5a439edfaa582dcb2db317a28b77",
         intel:        "7fe2eaef921411bfe215194f6bb7002438112379fc6cb40bf459f43444eef45d",
         arm64_linux:  "31e784b69ff1396b3c35a8001b9da6f3bd983f917cf7889ac192f5910c2c99ab",
         x86_64_linux: "60855021a4ac901a70717e25505000b25a1159a472f9889791b019c77db358df"

  url "https://ghfast.top/https://github.com/github/copilot-cli/releases/download/v#{version}/copilot-#{os}-#{arch}.tar.gz"
  name "GitHub Copilot CLI"
  desc "Brings the power of Copilot coding agent directly to your terminal"
  homepage "https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli"

  livecheck do
    url :url
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
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
  conflicts_with cask: "copilot-cli"
  depends_on macos: ">= :ventura"

  binary "copilot"

  zap trash: "~/.copilot"
end