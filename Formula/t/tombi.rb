class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.55.tar.gz"
  sha256 "1786610ed31d02b1fe553510ea7caff758f4c243b241ca3c7cc6683cdfe1505d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f854d2d718cd67679a017d61bb257399f555c6f85c377fc0d49d27acdc80ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a827f1b3ab600747b680283890bedda47843204e32eea39ada14d19f8fc90e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1dece40e731cffb148b91b8cd76de4985b1ba84ecba2486857102683d0f316f"
    sha256 cellar: :any_skip_relocation, sonoma:        "586a59560b572a46e536b51b9e11adf93a214ed375eb91685ac563a0c107cbc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b62ca05bbf62ad0536492973d02d74601cd60143902696a001fedf7ef658d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085e65c23fcd7370e30b1c1350bec26b97c8c1d807204cc90c1814670662e1a0"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end