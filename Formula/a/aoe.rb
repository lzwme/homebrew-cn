class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "7d231d02b34ae1cf910bc35517a89abde77aeb6f1cf0b6bc3cd1fe9b73779112"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d719cfa89e9783fea12c9686b9e6afa55d8f4739f4076f0f2d156886891cf26"
    sha256 cellar: :any,                 arm64_sequoia: "bfb27b0eb6e716a3fd693d40dc63d15bb47dbdd6ef23161936aea93f20ad9286"
    sha256 cellar: :any,                 arm64_sonoma:  "3b1e75b9dcbf8b9824c77f2b3b0d509e89577960e222a85034fc59cc8fb2ffca"
    sha256 cellar: :any,                 sonoma:        "9a03669693ee93dc50be4a72375a6f3cae0b542ffeaf7c2b4144f49ba0857892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ad3aa992f42acd077b772c6dd0e4890912ebcd24c85661be6a275f5f43c7f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b6513be9bd1a1096043ff3aea5e508cb9475ca09b578cd6650933c21d82a25"
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