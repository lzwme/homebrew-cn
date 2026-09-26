class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "1d91b8de9e6227ed7cb8c55dbcb460faa507e132788588f3cbb46e27bd6e3962"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80e5fa2b40f321c3903aa7a05011e38fd23f7b07fe85aef1a3f197e71026816e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56a2fc3edc4bac2893cbf124eabc851beb78bff966b3b47dfb6409a3160dd121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0aa65dc19a5f2562779403a25dd9a6885c010af04b920dbac3c03b996af1abb"
    sha256 cellar: :any,                 arm64_linux:       "9b70b92071c0582a3f7b1236fafc1ce451ba107ded6b0d32141e0deeff20eb90"
    sha256 cellar: :any,                 x86_64_linux:      "9fe79a317c1ad8d128887561fd2a03a8eeb5054c152b5ff2346455900728117e"
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