cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.40-0"
  sha256 arm:          "f69a25bc4bfec39fe90a6651c45439c50f5b151427e47defc07ccf93fddd490d",
         intel:        "2fc91672283bc1811953d12b883ed49644b76518f858da74458be0344db30ce7",
         arm64_linux:  "568697913e190847da956579b934bffd49495778d9c25b80d0f0bfcc38d83df9",
         x86_64_linux: "48d26c6d6ffa4962f18efaa734e2a9c7c30f867c83a4f8f05482b905e67f5ccc"

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