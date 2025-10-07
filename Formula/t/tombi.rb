class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.24.tar.gz"
  sha256 "7383e5c965afb68e2367378ba11ef176105053b063a7f9302499601a215d50db"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec18392a074d4faadcaba998c5a1bac830f5e9e6f68079686fc0600a14eb8de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e766fde50d127fd20f3bf5892dc58a1ad082f0fe69bc3746a17da52c141a3d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8a8a150ebf6dbd56ea944449ab4c3e6aa64dd182225a172e69c8dead59db27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "16611b7e83e08be0dc041751a61325bd8518476101472622ac7ccdbac9c79af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f81b8b0b12ab93948b13fc603b0e5fa6f9e2df6975e1e46f4cfcdb4556e1ae14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31e16803d1c92ddaf7d4ce29bb663665b53f3f688b9b318ed51233ebbb0050d1"
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