class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "db07e52dd891203752b1b89886e2c10cb09fb7b8ac01abe782df79285e388d53"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8666009ded3278bb6788baffd7bd5f57c357a4363ac69ab7c186d767f0ed5cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76f54e0a70027ca4fc2323b734992a67e08d5aa82da52ebd6e080db56ff5639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c393827f69927e0beb86d93de73120ee8ddc4fe2b8524807a05772ec7404146"
    sha256 cellar: :any_skip_relocation, sonoma:        "128995d97e943b4f7e8c257d2362361a980ab80cac6b22d632db7a4d4dc18b43"
    sha256 cellar: :any,                 arm64_linux:   "0915b3db7fe645c3c80b82fa51c745d9506ff8cd4d122636dba826ab8466a9ba"
    sha256 cellar: :any,                 x86_64_linux:  "7d39246e76951409d78675bc1a905f2062718f8fcbde7637fde6941d112e0e44"
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