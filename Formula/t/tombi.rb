class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "e1d5cc41440df67bfbdfc5aafb2190c84784f3ea262331511d9160d01369f470"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a147fe80a4c007768e592530bd314d3d2f34f43aab03c8e2c4c5fc6e7b5e5006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb1515a31cf0cfdf9078303f2b93060d69af44123700776c2b66c8d753d7a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c222298df0f5e61e84797fc9cd9ec8ebfcfb3ede49b0d162487b05e88d9a93aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "13bb626732eb8bb1776e8c9227992ae399d13d273e907ac69864d9761e593b95"
    sha256 cellar: :any,                 arm64_linux:   "b9123010ba8809658ac53c6428fe2a7d23158639c4e56e7bddcedf3dbabc61f3"
    sha256 cellar: :any,                 x86_64_linux:  "8f2928cbbd2a1b4fac706da3434ab4286ab7d45cc01507c3ec695970f11b2c41"
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