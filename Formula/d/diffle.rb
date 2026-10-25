class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://ghfast.top/https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9069c8a69ab9370e1d6763ff7051f8820ae349dd7ad9a91ab8aa5a15f81d21bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e5d385ae16d152d4a925aebdb072f9ca05f849acc6347eba659c3da1253804f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d78702f1c2709e137156a21b26d872eacb5b7f389549f78fda79b6e42eb0534d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42bc15efc71aa64f763fd80b3d1faa0733de334a117e0d048e3ef3b255b3b4c8"
    sha256 cellar: :any,                 arm64_linux:       "94d4b71cfd9931edb7145f181e4615998f05f2eb07dcce9d6f80a6410d9cd824"
    sha256 cellar: :any,                 x86_64_linux:      "4c33972499351e0bc16e6b98b7698504c6356e6690c448ab69d89345b5520a23"
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