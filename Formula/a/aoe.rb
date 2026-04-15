class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ed97ee026e3f7119309de13a001423158b28823ec2636501b7141db165917223"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be08542a6ae05e3c006825d906f9bbf9dd09f74817b1cde351350ca8b6558292"
    sha256 cellar: :any,                 arm64_sequoia: "84de3f3d381cbabf234a62436d32ef400815ac55b5cec7ac6f149896ee6f16a4"
    sha256 cellar: :any,                 arm64_sonoma:  "7b801c09e98bec31f858b3a2decabe3c7981659be68a625380b4d1d5ceb6c594"
    sha256 cellar: :any,                 sonoma:        "54026e83fd0c8f27767c461993e07d4939c004bea99c949b23209954770342f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae589fceedc46191f3e5877d203cae1444cada6ab64e51fc94811057a5a54748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5db46688d274afacf5df5ad772bc97dbd69ec023e44130bb7926b03fe58646c"
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