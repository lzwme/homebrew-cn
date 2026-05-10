class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "b945cf6012af9957fb52bde7ec19300f2cb51c6546846bd83447d52fe6bf7a55"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "120e92ac90e83b40b7a2c7cc1311bcbdf2a82575a400eb5dedc2228deda4eb5a"
    sha256 cellar: :any,                 arm64_sequoia: "c304ff8f07defc5c38fdbae937b1427cee7d9f0e3e8d2606bd4829dd8fb7080f"
    sha256 cellar: :any,                 arm64_sonoma:  "b94e44d13a532f6c14fef8fad72ab5f81547497e5ca661a396167a28e1df6fab"
    sha256 cellar: :any,                 sonoma:        "e0f2721f1cc80dc53b4e6714eed47fad34ee27bddeb4575e8fac6fe3e3a69732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99099a65f233965a7a26abe8c11188437c9e61a968850bfd676421326d0dbb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781404488b2d427078f67e0c4d13fa206b0b3dcc8576657c63604fb32d0f8c26"
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