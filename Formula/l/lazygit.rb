class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "198602c75c0d971b56088d6d364aaf9b2fd52bcadcb0e6a8548df0ed43e4dac2"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f2783c3879749744a9b2a9ee2e8d701838b32e6cd75e69a95c14b25e2438eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f2783c3879749744a9b2a9ee2e8d701838b32e6cd75e69a95c14b25e2438eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f2783c3879749744a9b2a9ee2e8d701838b32e6cd75e69a95c14b25e2438eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f60454d6cea26e0500dfa6e19b2b27d43e041621dfa1acc431de5bec261c452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2af8a8dd848fc13c802def4ed99ed8844d40e6a65b4eed8b72b539554f24a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c3d643e582be489e03c6c7bccca819948f55a215a2c64c1b194fb201cfae7e0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit -v")

    system "git", "init", "--initial-branch=main"

    s = testpath/"test.txt"
    pid = spawn(bin/"lazygit", "-l", out: s.to_s, err: [:child, :out])
    sleep 2
    assert_match "Log file does not exist. Run `lazygit --debug` first to create the log file", s.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end