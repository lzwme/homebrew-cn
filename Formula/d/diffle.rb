class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://ghfast.top/https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "2000ef0967d63b46d4560aa11b77a410510070063ee03a552fa8c281aaf6e579"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cc84bb95d075987e59bd9bcbbea9ec617be601d2cdb91d46f7aa3ee90dd2b2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d67c6e3e464ff4e0b79b1a68490926d611590434ddb01f99d401c4b96ab7502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9e9c247f57dbf95ab48cbbceedb479e0bf63e5aada0b546a290d703274b710c"
    sha256 cellar: :any,                 arm64_linux:       "45b1bb569168e0c42bc62e121fc271b700b4a626390f26e879267ced6dd8e425"
    sha256 cellar: :any,                 x86_64_linux:      "9e369aee45b556bb3a09f6031ef450a7f2e66c6c87c0ffab5effb62d9638f4fd"
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