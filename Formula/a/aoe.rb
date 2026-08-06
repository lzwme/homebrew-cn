class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "f301158734db6079a5f84235e6857ed3f5c22a290c993c46a63d4b964231cecb"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca957de77b0c835d2f3e67a2c08a28dc5ec815d5577dd81d4e9e7cd144432ddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8db1a69050b46f2b1ee1f84c1011020c6a150fd872c000c796e8930722fccd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ecce80628ced346ef62df313b982b75a3cfd0b80df28975b234d206ddadfc39"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ad6da7328de30604eb1331b3e81ea99717e7f0a163938ae81596cbdd6e202d"
    sha256 cellar: :any,                 arm64_linux:   "f8a8733756159f946fc4c699a01ef19e194eb477b2f9a7ef200f677dcec471f2"
    sha256 cellar: :any,                 x86_64_linux:  "0dbf7ca6b4dc19ac6a02be6faa78f18f852935dd68bf4fbc1e2a44e4a7cc8be8"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end