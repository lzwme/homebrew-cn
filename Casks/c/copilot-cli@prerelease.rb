cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.37"
  sha256 arm:          "788ff77231cb511605aea197227cb673e933bf827bceaa36d9940ae8bb4ed35a",
         intel:        "352ca076239298987c0b3ae09333b88c22b7e819dfa7be1ce0b50ba4f6fe7ef6",
         arm64_linux:  "71dc5004bcdae319876805bb7ba416d2633d90d5236ac879b80f168df1d8f3fd",
         x86_64_linux: "20a38271a9b88d0a013f5be50c7bbe8af9a85f7fda7d848421e6d6ad7fe8cf8d"

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