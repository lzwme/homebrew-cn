cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.415-1"
  sha256 arm:          "1e700fe8affcba6792433ed84bd328c9a5ea388ba9860cef7ce4530e0827ca34",
         intel:        "0bfd3bfdbce1fb540ba5b7dbf8404a7b224bbfb4f97ef4ee39cade2b646506d8",
         arm64_linux:  "36a42f0ad4cdf41cde5b23d2cad15b8f29f59956c266513022ada8039b76248a",
         x86_64_linux: "48c20c59ffa019d669b6fbcf5ef83871a535665f07a9c00cf7037702c0894021"

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