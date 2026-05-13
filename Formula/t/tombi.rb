class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "fc365f80f480785f08cddc9b09fefacb9068d0c7fe8715b25d79943b515db809"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "244c1344c55bee993934e9f49ee73a881f2c27d6df62bcda5c8c77af86461374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d8a26f6bb60f20ccafaf224a237ca0bb0ce55cfba25f61bfd2615b0341a3d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d897c2a2c977f5683b10cb1d2ba15df8b47819e0936587797dbae3fbbe9713c"
    sha256 cellar: :any_skip_relocation, sonoma:        "941e8d120428d2338db754e831233dce1eef08f50d6d3a9c3aecc638d6f67e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c21d8766340febcc382a2a4f555c918a44c42f90071eb1aa7ba728c8946235a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f62806dd52e6eea9e634c1a54c57b88417660664565e199158b11709b13a9c63"
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