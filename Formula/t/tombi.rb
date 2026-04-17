class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.18.tar.gz"
  sha256 "e98f3b47c9832f7a526c65df46bb00f610b714422b52b81ba1c66e269270eff6"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6981f3e20dd0fa792c4def580851a9fe46161593e7ceb88d1c2e2d2a2d87da9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e51937dd3541b89ecb864acad6fbdc76808d1df4d2a4701807e4c035d860e416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd50d88e209a816f351a5d00158f836af94d589eccaf276b4d4c9ff78f0ead5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcadfa3764615b7b5392afbef2051c5476d5d4d90c435c3206fb48844377156b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "898dd8cf0d43d3f99d8740a8e5a4bce3f11b03e1ade08686d7979fdbd220756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65628378976054ac34a6c7345b232de69a8578a6fa639a8807655058582f343f"
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