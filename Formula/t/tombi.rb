class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.26.tar.gz"
  sha256 "24c62e42b97b9584c75778fe27e18fb77398c4fba561f999ed7caf838db70363"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b634c8c5379c36fb97029d9b16e1ba647bf52faba4d1dda04a7a777ff14144b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89c1e1e44bcf568c8c5e9e9139a37062e32562ecf7ecd12e362a73c7d4f439ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83ffb8334b44c094d5df0d26eefd35c441e0430bc630b5d1fc60413a2c87e4ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f5300f3ad8b20ab6b9c3e2cc74a13dd1be5726981901b978c2130a92c7e135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2641187f4ee9a7c52c091b5f28a54b6df7e8c01b1ff1e64a1c934e16955d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46fec5fd669228d3b42d116c0f4fd53b206906266fe7ea9e0c302b99a06182c3"
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