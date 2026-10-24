class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://ghfast.top/https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "48c4a2d5929b2d96a62d0262360f8e81c97da7f19c6b78aaa574c3045e944c58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3686daade3dbff8bff8d7c45d74147fc57a3851226830bacdc50a64ab3eb7aba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb6901097a47e74310451cdac88d0aca316e52dc79a719029da17a25be39888a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de739741fb18ae47149d4f12b8f24a203fc4778f850ae9a21d3778d5ce89e0d1"
    sha256 cellar: :any,                 arm64_linux:       "57a037ba6225068d68f147cca465e5ecb23326f18c0b6d2ed15ee84aaf83eb7f"
    sha256 cellar: :any,                 x86_64_linux:      "f73afba159e9984f6f8c6b41a1350f3edbae1228dcf66bd37634007eaad8a5df"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "npm", "ci", "--ignore-scripts", *std_npm_args(prefix: false)
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "npm", "run", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/diffle")

    generate_completions_from_executable(bin/"diffle", "completion", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffle --version")

    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    (testpath/"hello.txt").write "hello\n"
    system "git", "add", "hello.txt"
    system "git", "commit", "-m", "initial"
    (testpath/"hello.txt").append_lines "world"

    port = free_port
    pid = spawn bin/"diffle", "working", "--port", port.to_s, "--no-open", "--no-lsp", "--no-watch", "--keep-alive"
    begin
      sleep 5
      assert_match "<html", shell_output("curl -s http://127.0.0.1:#{port}/")
      assert_match "+world", shell_output("curl -s http://127.0.0.1:#{port}/api/patch")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end