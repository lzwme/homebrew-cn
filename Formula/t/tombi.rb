class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "099898b4bc8214c0f4195c1f554fa96d6e4a3be0541cf67562d6bb37576ca8f0"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95d7c11f0df648b7d442e8a4d252da40744fd7adfd29d3bb86b80b21083b3580"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef78ec9e991ebc563c53756c5b32a045b91567a15d528488c14c02f4c73523c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31af3c7a281e8e16401d783a6b7223a5f258110715c2afe9bf2e325e0ba0efd5"
    sha256 cellar: :any,                 arm64_linux:       "15b8de9aac2654ce4750da1acb64c295c11036dc75e20d8f64b99895f75dec40"
    sha256 cellar: :any,                 x86_64_linux:      "90d21eff265094e61e304d2868f709ae4f067b3e0e07ea78dc865d055eb7ca3e"
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