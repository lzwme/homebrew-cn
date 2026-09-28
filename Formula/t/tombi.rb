class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "d38ef65a4150609714292ef31633ddc2ba666f7c6d528710cbb1e6d0df844f1f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ae660870569eae043e31f1de343aceb4cb5488d1fc3270e164a37587e21106a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b57f6375f67943bd045969da80dda65c998a9b483396ab4f2c7cbeb380d289dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f2bb27c97ad6517c709c0df68d095e1873879a8d67058b9a5a5da5a0d2fae69"
    sha256 cellar: :any,                 arm64_linux:       "5a01309a39ce7180d338811242f70e9248d489c646be6a432636ae014f9cbb98"
    sha256 cellar: :any,                 x86_64_linux:      "d530df4b5ef7565671f8612e3fad90d50d371bca1925fe777bd37502d470cc0b"
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