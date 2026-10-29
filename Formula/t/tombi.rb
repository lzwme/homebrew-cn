class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "d5868d6524c65b9bead3cb0d3797a47024bed901fe2110d0015935b7f601e1fc"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f68cec4f41ef20f79e618294456be87a2a978e731ab5b6d4ca02474bf0fd332"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce6165dcb3ea381e43b3fca834365c103f9da61cf45d093ec41603d5b0409a88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d8f478f89d66582dc7334eb90df5ffced72dba292bffd5d8aaebb02fdcca6c3"
    sha256 cellar: :any,                 arm64_linux:       "4fa5b2961002c5b362876ff03ee50535dc915f8845336a319abc72ed112d30b6"
    sha256 cellar: :any,                 x86_64_linux:      "3df7a57b18c572794559ccbdbbfe7e54890466c2b2fc3965db615cea9b18ffba"
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