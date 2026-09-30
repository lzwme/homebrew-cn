class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "ac086fe929ad8267e746bd05ac9aa3cadb057841d12b5d8c42bf53d3d584d02d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8359d71691e31dbcb5f8b8a27bb04eb0496501d5face08b32a9f37f70927a09c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75144c4c90da5b8972572dbdfdb6f032e143087ebbfd3d74b4e8368eca91a31d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ada3b851f2a4e7dc3236c7237eb1389c6c0817b4f4a53d0ada11e593badab8c2"
    sha256 cellar: :any,                 arm64_linux:       "0768fe044eb0e65bd53c77c9b3330582aac5596a4b01af48df260eacf957fd5d"
    sha256 cellar: :any,                 x86_64_linux:      "f21dadb02d914f8a643f3f479b2b7bf8fd8bc9791e9ce9048f49a59d48ca5cc2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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