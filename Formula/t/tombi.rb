class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.50.tar.gz"
  sha256 "0f602ffcfdcfa79e52fde3226cdbeff9ee5be8b7a0331d76e0e23daaa2c38924"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e1bf28223f20e64a2fe88b8de84d6587f9e841c2addbee61a1de9fd3cccff5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f14677b0c150619dfd69dc8cf022a629be15ec082993e3f662bf7cc5aa9428"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c85b9a93637b28682a2faaf533c194e25f782956b2dd1099ad93aa8c2a72de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "484cf1de991c31465b6e538fcdf633a2dce7faefae9d7883803a94144d0b47fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61615762af9a8a4b74332257cda20c455f1e6cf8f74bbe576fe377f3db9e8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb31f370a5e429e535e44f6728ad8b16bfceef82e1697c2f9261d33e609f6cd6"
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