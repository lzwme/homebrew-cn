class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "c2abc8324edad8bf0d1d4bb632d3bdb4ba392d07b84aafca7b3ed9825824b692"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1776e92c88371bda0b1a574eb4768eabe9bc6db0f08966fe50621522b30ddd59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f09f80f774dac54c46c92bbfa85f250779da320362f804425666bde4a2017751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64998771cb97b35be99e8b26dc2705142f165ac5f5535e1a9e12347a0573b351"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc816c3c7d7e08400aa78629ffdbddbedea8259b6587b9fc8d6ab4e8a8f389a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "603cddb8c0a7555bbd83228bb6b08b95d35da751a9b140af6012e858e56d3439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d6d7ccbc90becc3de9f564ae2551db3f391157f5584aaea0ae3a720b9275e2"
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