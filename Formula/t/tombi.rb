class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.35.tar.gz"
  sha256 "c7deb678e6e083e0225cdb73916df065038f4f43345a6df0f2e42c44959aedb1"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98bf386ac5b3a52d08f1a58f702ab2d795ca6757a1f2cc58ba1b2390b83c8d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef45c8e3b2367a4aca8440f76dba77f8c68db2e3deb2e664657d4fa42e8e4ab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "339eb70b1993c2e60483a4c566086cc47e8336bbbcc9a647668660b90e275e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1448bf91fb90c2083acf82caf54dbc9d9c13622d393d3a26cd248f0b29c26d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd2afd071c7f90ac606969bf553a15090a03d24a8f2c5963f482f1e3baeadb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a9cf234417b101085eb19337c9d11cc1ca7896555c2e852d359698289f47ecf"
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