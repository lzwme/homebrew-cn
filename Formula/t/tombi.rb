class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f2c9d359610c4473615fabc74900859b91f49db767122d750ec59ce6371576be"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4168396ac32ca6091c30affbd58234720f00d075be92bca84f38e9eb65682f0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c50081b495b23f530a9828f5af88a613ad06e4a527dbe97564dc2ba08511c3da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81b6d256d908f6a099052c7f1d3220606bcf6f52bcd080079815118409d8a567"
    sha256 cellar: :any,                 arm64_linux:       "063678a33bab94440a6fa804571f9109ed94204b5d86293c1eb3a5f608afb82a"
    sha256 cellar: :any,                 x86_64_linux:      "54a41239d14af40944a3beb5d72eb5a4fd3cbf033092d54f64896cdaae8021fc"
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