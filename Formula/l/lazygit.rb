class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "2d41928fd3c6355022f0876ac5b8abc89ece40bf3ab9b8353f254d420d938201"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a4ede8fe3174754df4a15926411796753c4432b1c16242e09a450469c9da508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4ede8fe3174754df4a15926411796753c4432b1c16242e09a450469c9da508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a4ede8fe3174754df4a15926411796753c4432b1c16242e09a450469c9da508"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b5406c979762959aafcdcbfc357a62209e7a3263beadd5bffbf5ebfecf16399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a4342ec8513db16b48707c453f480d55b57069ca672df85df39bb8561ab13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e0477849b21f65b81c8dbb5c66312655117cb1ebb2aad832d0cf65ce7932ee1"
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