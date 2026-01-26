class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.25.tar.gz"
  sha256 "8f31f5414a76dba27b125b42bf204b25e33b9bfec39baabf0e6f4b90f9ae7e8c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71185b337f9b99c6181ed6dc01ec3d2fe4faf13f9e5f4c0dac80baa7b4222cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a25c4171c00d6f6ca2d778c6ab74d55c8c2de4c261e97aa17e399f0041a465b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8032bcd59792e8eb20f0bfe67d35bb136205f871b0329ed2c945b4a42f48e9ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "446f860a0c888943ecbe90c0d3968e77cf9afe87d3417019e20e7cd0a89db898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edca1874f49aa567243ca15971007b9d661662349db7b9f1bf5b8ed9d13edbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df9f44dbeef743a4d998d79483d5cf157ac0fbc1b515c4b7b9bd99976d95e2ee"
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