class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.22.tar.gz"
  sha256 "4ddcc19cd76c31e4c923511bcb1224e44ee381725f491f9ae2d2c69249b06e4c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a166dd2c44fd41f91b1783dfc4fb8141c059ae8985d30c4046aaa78ff3e9ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e715d5a4db683e6d70e8649af31e70f57d8e1c81e341e333ea33a8ed81b8dce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2458a37c1602278238ed7b82dc1c16d90739dfcd334f80b5f5a1b5f86e75e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "923c4488de6c880a23dde3dc705e5b1f7fa31b620bebf349c6c0c98bb8bfc0f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83bc0e0ea8d2689b6a5f15e8216bbe824cd58e2ff3fad1ed2c11c5e674db20a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c32fe5414f5269eb479d949a61d835dc3a13557ae1458e3e99cb4225b663e66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
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