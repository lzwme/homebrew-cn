cask "copilot-cli@prerelease" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.41-0"
  sha256 arm:          "d50c21c39f0e7a31c017de99e3153185efad62d3b9827cf16762b3176b5ae4a8",
         intel:        "57b6b3644129961eb21753600254989443d1310a13a7396ce1cd309a609c9506",
         arm64_linux:  "2545d83a5d93761aa0f09d7d6c1d853dc508c9de684041ffb64652da19a7951e",
         x86_64_linux: "2d33d05a6853dca4d229870c61e6936fd2f0dd065b5932c6108ba28dce2cdc36"

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