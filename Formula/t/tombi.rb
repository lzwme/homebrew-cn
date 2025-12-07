class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "302c18e965e5b711d8a741d9e2b640e82fb3e494073efbc88d8c8522b76c024c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00ec98405ac9ccc214bfc6ed084a776d9dfb6328590ac328271abcafaadb736b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d160f61bbc451aef3f31024060ecef69a8ed1f1a654010b856ff7c23e0298c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2feccf732da3da3ca4e00df0d94cb3ff28914c0e93dcb352413bb6baab3aad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1991d111d5d8f0e3f51ecbd54d68ce5b6c7c8aad0f5158313b47fa242deb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72646e525578a63c4e4bbb357ea9280ee52cc7cf225dfcb9444673d88c73544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cccb2b2e0332e55088353bb977901d66d898f2128756e3d4b993cfa0d927819b"
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