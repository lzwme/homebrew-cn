class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "75af56fc8df60426f7b4fa0a3150543e5ad82ca9bf20de8621e7a2b927f26ebb"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3996b8d7188fa25215df20a356851ac51c587d789cb7455d63300c8493c5d397"
    sha256 cellar: :any,                 arm64_sequoia: "7945673678f9ba7a5252050be59d854a97c8061df3b1ed4f2ee87ad027b064ba"
    sha256 cellar: :any,                 arm64_sonoma:  "0e207d4a0701428951b107f3045de381e5236170521c858977269472fcdf24e5"
    sha256 cellar: :any,                 sonoma:        "4b4b6c5e3e0f892906cd831aa65362bb701f79c55c61e2c11ebff80b2c05b53e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800469e56406bf8fd3a21b45807d57bf66f2965113f496b115298d24bb8af7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c0bda07ed9a9ea9b15e2c04b0bb710ed032d8528a3ae29290b77bbb1e51256"
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