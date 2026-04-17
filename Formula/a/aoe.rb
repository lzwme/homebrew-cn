class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "3f2bc495093f9ecf5da8295b45789c820f97ad03fdb76a99caf8272ad2ee7281"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8998b29ab381d6aba43d3a543fa735aebed244796984a0a7e8bec16b719cf5f6"
    sha256 cellar: :any,                 arm64_sequoia: "b8d0f4ac548eb6fae0e0d7228ff70411d4b9e9edbd7a6731f49b1ddc8b10a420"
    sha256 cellar: :any,                 arm64_sonoma:  "d5c35792ed72fa84b648e94ee4449138e72c059a0cbf83a9d9ca7902eca65c68"
    sha256 cellar: :any,                 sonoma:        "de64d188366f7fc9fc2f55df70277053fd3c0742506a1a6acd93a4454eb714b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ebee09158119ab07af639be041f4601981ac7a74e181aead54262f4414a46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2310c76d5c25461f750c955c7d09f17643e914ebc26234b2b5a8ee1b288349ce"
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