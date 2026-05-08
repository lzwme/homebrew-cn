class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "13315b24150923e270c2c09b2aadd405aa94f72a4df50318eae03184fa08829e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdb71d4357ff678a8c33c73df22751f97a959ca66bb8b3628eefbf3418783d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb316f571c6d07b068677b92cdf6887ff6865b1e15c8946965261a5dbbff4806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131ba1099b3259db39ec4b42ce573e016da3ed2cc94b0f4c84f8cdd9bee186cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "77e9f20a45f8330e22fb2198975d3a96164aaf26ed33dceee6f62410a9cc0401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc4b232907ec25fcea8d6e7cea47702b90930837d8ad3c4fb9303c4137fc1831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0558030e894f0f31771be28e72266599f6212d9973edf137a3d8efe82567a3"
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