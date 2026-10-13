class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "91e944e66ce0bca5d6cbc32cf50407512e68c269fff8be73840d903cc4178c22"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aca3393c76842acbca394d93cb51f868c9ac702aa68515fdaf258ce2bd405f3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "187c2ff7ef179da9cc3f533621789b77702f56541712353c150da5fefea6b047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a82786081c1a68e8ebabecfbcc184bb6b0e59ae9d6115d2e5494aa003bb73c87"
    sha256 cellar: :any,                 arm64_linux:       "1b2ae9ae2cc49368fde1ad68965fa3981b675b068bf2a9c47d7dfb231474c2e7"
    sha256 cellar: :any,                 x86_64_linux:      "ad83232ef62f0f086373e9e652b480ffa5fb3be989bd92301903125634587ba4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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