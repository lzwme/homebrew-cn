class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "b54bb7b8c88f00277e170042fd5c6ee43ab72f6b1df52bcbc3d9b96ba8c9fc24"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe9d44ce2b5a54f39281d95bac4c5244141d6aff498b5cc24f4357f2c71aa2e8"
    sha256 cellar: :any,                 arm64_sequoia: "01aa79410b2d99a9ace86b4e6e0eaab64b2204cb83389200f609e7092073d15d"
    sha256 cellar: :any,                 arm64_sonoma:  "df64e2d0274f0a847d3bcfad7fb55450a0fac81bc74dd280636c7047ddc819e2"
    sha256 cellar: :any,                 sonoma:        "8b1dbf56338f3ec8f680c6a63c60f4a2f5e9dd55252a55b6ea968107f0c6da67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d414a4882939e302d8d45823926994bbd964a7b5b9a8b9fbdc2f21b48cfb0c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd6ef1c5dce687a93d791f279e5ad2810b951bc29028a3c4f960461424c642f"
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