cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.419-0"
  sha256 arm:          "fc1396b41ed54ed9f36fca9b0752b3001c84f436f51c6e1a3be620c661ba2323",
         intel:        "6738700952d25260eb7cda0e20f8b362ab151d19166f2a9f5b686d3095361335",
         arm64_linux:  "5193d9dbb1dddc1b0b8aeb1029ee85296bbe0fa88ebcd6cee39015760bc97cf7",
         x86_64_linux: "fbd6b0785624ccd469a6388cf0fb7ef22b0a89d7c5fbee40abe982aceb6bc77f"

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