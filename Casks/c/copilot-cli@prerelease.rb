cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.40-3"
  sha256 arm:          "b0a8badd07afb1994ff26cff894ee5655f701368d85cebb7f0c450ea4892ba04",
         intel:        "facd5d4e995a0a4b06310549926a4983dd5c02a067b1b68ce47f201ab8c4735b",
         arm64_linux:  "9c07722dcf8b638e1dfaa6a149b2a5fe023c76917955bb458af3bb46c883f553",
         x86_64_linux: "1fd6ea838b2e3074cf7eb0b42a29240629e566a3e29165b40525a8b15735c1ce"

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