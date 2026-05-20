class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "db0d076274918a3174b33a1ea7fd9f5fe041eaaae76e7aacea1d4e97529d2137"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "610908562c7c0b33fe6c2dfee30a4bc4c2f65f043ca7b6ec07f39a2462f1c92a"
    sha256 cellar: :any,                 arm64_sequoia: "0f31461ddd6ce9465e98c9e0cb043a037f270786614c403834ab477617f0268b"
    sha256 cellar: :any,                 arm64_sonoma:  "423e18d64c6ddb273c02aea82d264f89adb1ed8897a4f66c748403ed8df045d4"
    sha256 cellar: :any,                 sonoma:        "5c2d888d1fe5c6710519fbd8b1fbc06721c7e6239bbcf8fc0208cc4463815182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b9d9ef6a253015c0016c361f5f0bb3fca524f32859f48f398983555a809771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe07f77fe5be1f048c74bc3d0477b4e083de40b21748acee3421b5894d2f259b"
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