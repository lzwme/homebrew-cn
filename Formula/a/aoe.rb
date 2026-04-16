class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "6f4853c3c1acd9031f0da9b5c4d3a2ece3142f48ec4e4a32b15240f43c56fd74"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c4bc00aea343dc2d69babb67f0630f4ad60f8d7be1cea81a99d7a3b7fb74ad9"
    sha256 cellar: :any,                 arm64_sequoia: "0395eef6562def5a217b5f0afb7fc0fd372c4b83e83acc1873195996bcd9dbcb"
    sha256 cellar: :any,                 arm64_sonoma:  "2c35b0ee232c9e69fab09a30df1d8075a64abac292545519689d735284f69aed"
    sha256 cellar: :any,                 sonoma:        "29898d98f7ba85e7c7d42de927b0b6180d4af895eb002928c400daa3130abd80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84269629f91e610a634af4b836ce856e8509600c77ea3141a38d1fb754039eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a455b94b7b63bf0670e0e52f929beb0051f044d20c89fc5b105e0085bb0b47a1"
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