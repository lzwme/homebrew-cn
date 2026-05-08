cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.44-2"
  sha256 arm:          "9ab14e27191b1b9e450f9a2ebcf0a3e5781ea2a509b0aab4d6e897decc7c1779",
         intel:        "cceedb5a19dff905be966271e958e4dbfda6dce6f7a68f4227df90e6fcba7478",
         arm64_linux:  "17a00c9ec95fc69ba93c17eb7fc12a819c392eb1e332eb76ca269b46f897be96",
         x86_64_linux: "b6aa5d4040136542318873606e1aecd8e28346c69055ce40c671e75963e4e415"

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