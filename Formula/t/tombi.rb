class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "4ead5552a48d4904ccdef72f867569de1f7f06ed02d201f370231fc2d339eaa7"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d48b75eab0ee5b1738723dc9883f00ee9ea39b2b312e8bf5eb66486b01fe963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25145d500ae7ecb7ad60e29a71dab62fc7adf279f44ee99463669b5a5bbfd97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95848527ef953484016e47756745355471a52eff2815ff9aaac58c02e8596e26"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f5ee0401303eaeb4f19031958455d8b38d496e14f3e5aa8c9941e6f3041ac05"
    sha256 cellar: :any,                 arm64_linux:   "0545a5c2596398f540f679eb490bfaab90b43e7415405e46113dbbff3cda0c91"
    sha256 cellar: :any,                 x86_64_linux:  "76bc4e069e389271f0650cdb8ade9a6f95dc22703f1cb488b9d51d7fec657aad"
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