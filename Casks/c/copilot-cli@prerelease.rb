cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.420-0"
  sha256 arm:          "e59d7daeae24b11d97a7627199ba3ed614579cd2fae4449bca38453aac935fea",
         intel:        "f0bae8ca6caa6bb756024a02c37c927570e0dc7cab7ed065f47c1b0d2c21dfbd",
         arm64_linux:  "1325fa6591514253bd77cfb5bc51d6bdbaa5d5987b77a2c77c6db794843d7851",
         x86_64_linux: "557a01f5d7319c494f3c157fae575902bfa8f8877a7309fa09637b5c99ece98a"

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