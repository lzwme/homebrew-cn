class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a9c156e5ed0e8dfae069b45bbad5ada3eb8ca833f2176ee5bc891bee877ffedb"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2590bd64bb57ef50c490ef3db7d9ecb43ad5c311fdd95572bfde9449539029e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58d0267bd62d2dab1e596b2cd94e56782b732b69b14ea51bc66973d1520d2f37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0ec81396bd361e5a1986d5fb33989c8ca28a7358c8636dbd2f0257d5114421d"
    sha256 cellar: :any,                 arm64_linux:       "b391b8a2b89d34afa9d957951c253703d8ffc6338aaf606eafa9e41de38cf930"
    sha256 cellar: :any,                 x86_64_linux:      "f7abbbdaaca8adb8ebe9994547301aceed32b2a79e7522e33e971f500a5cf59f"
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