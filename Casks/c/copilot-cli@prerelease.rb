cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.419-1"
  sha256 arm:          "0587d70862373c98b7bf37d9a982e6061358de476f15168d8572a09bbf51ee00",
         intel:        "07a2f6bc36c51b322e8cdbe60222c622613fc084e8cbf0c3922bd5c5c59b53fe",
         arm64_linux:  "387fdc24d6b605f65da4bca8d0f11331ce0177af5301894aa96e508e84704960",
         x86_64_linux: "41a3522d8c594dbaff37822f67eedf021dd1f38c824d255bf5fbf3b303271ab0"

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

  conflicts_with cask: "copilot-cli"
  depends_on macos: ">= :ventura"

  binary "copilot"

  zap trash: "~/.copilot"
end