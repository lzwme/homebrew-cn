class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "695a629fb4de6732d29f9e28ae905c70a001159b8d9951a61a3f00a4738567f2"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b15158c4f371220a4d33e1f73d415e1dcc7d366339413f665515d940b07871f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1513c45ae2f460918d61d8b32fba045f246566aa5ba3e0469b3241db181c6bd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1941f730214d473b521f64157dc31fa1418117b28a679077fb4d135185d9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0163cd3b418a4a9d08701ec0111a8191899d6deba4f0ec2172bfd9155307a68d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a566e6d61df6a5c19606c57d589f45c486537ff5754202210ce104162dfa0cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17075f9931ae67e487a0c72551447d370df05e0e52106a6b9443f11404195ee5"
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