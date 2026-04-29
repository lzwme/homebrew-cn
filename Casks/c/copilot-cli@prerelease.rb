cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.39-0"
  sha256 arm:          "eb565d5dd7e61c6d561f31f0d84f62b2f1a737082240a3676d086f727853d3b3",
         intel:        "4569823a0066bb63f22d8d14afdb6ac69960d397585cec173ea09bff9a297028",
         arm64_linux:  "ae773a244da42111440311ca584fbc136febfc1baa3c5452f38fc580ee6e8635",
         x86_64_linux: "5b2cb82263c8e7940bc2c68966894aea07978cbccd789476d4bd27f1e489a366"

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