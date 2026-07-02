class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "c79c36e405a9fdb0d79897392e37eadb3bd38cc9d2527a9380d858f54457c019"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3198c8113e5524dd958f15d5119824f635c84be7a26b57edf7c63f6db82d1ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af54fa812d420191011babbc37048ae24e0018c1fbe76a3ad5e33cc992c71c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71cff661c535453a0e17a23bbfdd6efa15bc03abbe8fbe2c30f0caddbce4fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6ea1e9ca8c9417a3b675913cfc342dd745e196a8e28b286ad02f9282ab4b34"
    sha256 cellar: :any,                 arm64_linux:   "ff7ad820e1c28c5fd2d7df2c96a9f54fc7d588ce53776b2c530bfa7c8ac8c861"
    sha256 cellar: :any,                 x86_64_linux:  "2fe1be3a991b3d5705a5b3aad28ca3e87493df6bed205ac7613f903dc7e02158"
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