cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.42-0"
  sha256 arm:          "6ba58313dfc617f39b5dfa8e8d799dac934beeae722538dd08317544aaa8360d",
         intel:        "035cd600d319de9258e6bb54d25a3975ae1347018db87cd14553c24385926cbe",
         arm64_linux:  "0d27e0f3774879aa6cd085c03e317b8be0fb5f67485e6dfde5dc01db4373e77f",
         x86_64_linux: "7131b78be45c455d8563d45b8ecb1f90ed3704f4326e4b52976075e0893d5d37"

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