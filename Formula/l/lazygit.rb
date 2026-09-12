class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "972151d83d8fdfa5c7c881c34349ba4a38c37b7085667696b85c443d2fca97ed"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9145372a967c7eda15d3c8ff0434a3b9af5f7ab43c2176fee3ade80396d2efd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9145372a967c7eda15d3c8ff0434a3b9af5f7ab43c2176fee3ade80396d2efd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9145372a967c7eda15d3c8ff0434a3b9af5f7ab43c2176fee3ade80396d2efd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9145372a967c7eda15d3c8ff0434a3b9af5f7ab43c2176fee3ade80396d2efd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5cfcb24af1d4c136dce602b7d13c2c9e1efa6f3340f79e58b3bf4b7cfb17fc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a649bb4f3cf21da46871084146eb9f21de173b7f4c52505890877fb706705639"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X main.version=#{version} -X main.buildSource=#{tap.user}"
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