class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "04dfd8bc13f1e054fe2bd512e630e50f6f4855bf16bb0bff3409f6314eb7fc58"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7732b1386a1516a01b34495120ab8d4ca3b7ab7494455fbbf4c313330c6d435"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "169a0e1ea0ec760a41ef6ea2ce3f13c3db11c0bcc1e39195f2f765cfa1ea575b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daa6b134ad6ff4262754b6062a4f12c7ce63a43e247291fb014706dd7b051f14"
    sha256 cellar: :any,                 arm64_linux:       "4941094b5c8eee93bf0d6af4f2701727110b04bc85d4e42fe287dff961258943"
    sha256 cellar: :any,                 x86_64_linux:      "a2d6aa4f25d39d1a4f597d20c885d8b42bfd7d53d1def9fd628dea8c55ea7bc6"
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