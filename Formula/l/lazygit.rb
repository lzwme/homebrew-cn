class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "704b14509dae4c0212754d60d1c00181aea79c0734aafa2c83c89301dba1aefd"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bcbe4f7d747240ee5339ac7f75bc9ad636f345e99241892ba3d0466c7e1ace2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bcbe4f7d747240ee5339ac7f75bc9ad636f345e99241892ba3d0466c7e1ace2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bcbe4f7d747240ee5339ac7f75bc9ad636f345e99241892ba3d0466c7e1ace2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b60fd901eb9e711855c1b64e145bf683e869eeabfb7203e2fa34a680eee11234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "56a2ea6ba0838a305320fcca57e6286e288eaedc81b72d86960a094f0a3f7545"
  end

  depends_on "go" => :build

  deny_network_access!

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