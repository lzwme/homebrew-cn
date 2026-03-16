class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "db0061dac274f3d86046c9ec2f0b9a117429d28f090b12d46448b358817e07c6"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac16b2891aa3f7865f5228bf8b0bfc4cfdca8dee29bb06d0eca861b47e37a882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842de58f818b8fa5836be6501a77b1346abd3e001f41428e14b8d31a65743861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f948de35265fb5846f4169e2a89f00d0bbb97f71f086befb09811a1bcf10e0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6fb4f0e661c14a09d8ee43ed008708bf8c666559753086a1545831127f6b05e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd8c35091a8d36313b5b8e12ddc1ba959bf90a63b83d9ce0aca364c4faf2d656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2699c484c1ef879940750e90dde87caa8f72a93255910f87631494aeadd38d98"
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