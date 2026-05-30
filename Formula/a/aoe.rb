class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "84effe9ccd322e140d9fc9f4856babaed4b99bd7176f2229e0f7293323590916"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "93d6bac81057de6eef19db8bdaadbd3e486414189a71d9799f39281ef2bc09ac"
    sha256 cellar: :any, arm64_sequoia: "ca70a9c15d00b5b46c159dd86fef4723b1d1faf7b6653309f7b707c61f46fede"
    sha256 cellar: :any, arm64_sonoma:  "f1cb2d3b4e2c78af1ddef0e3f3f51dcefefcddea49db141a817b22e8462e99f1"
    sha256 cellar: :any, sonoma:        "3cbfc0544d612c73260619b9a0794fd5e31e63cb001e8282610e920041b6e706"
    sha256 cellar: :any, arm64_linux:   "2791f86be7c85e77bdc7ffaa71c0e14c47e1722509717e2fdb5a5a4addc82995"
    sha256 cellar: :any, x86_64_linux:  "46822045cab2fbb5efccde27db6090e817a7f34b984064f0b20136043add1925"
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