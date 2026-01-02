class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://ghfast.top/https://github.com/bvaisvil/zenith/archive/refs/tags/0.14.2.tar.gz"
  sha256 "5fa6873a5a1182067ed7f0355521bdb35498980b5b751f26e2e6fed93474dcf9"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20d44e0ace7d6c5cacb792f4f43ba42c2bcf2148700adc55821ca14f90ebfab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4607c86aa2a3852637a019d8521e160f9d04b97cdaada5eb4bb9bd2cfabdbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfb2449114cd6b5e0eae5b371148e55bd354f2a39e3dbfd88f1d1086dc689f60"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3df9898f37b0ff42f301f5380de9c7d1676ffc6adeeb01b0b50b269f245446c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c68068151c8400dde4eeada345b61370e72f7e266b680116321dd5de027a3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb801a64e46d5b5da4562868e073f48c6f835550d1b72a4e9c07deb5d0bf193d"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"zenith").mkdir
    cmd = "#{bin}/zenith --db zenith"
    cmd += " | tee #{testpath}/out.log" unless OS.mac? # output not showing on PTY IO
    r, w, pid = PTY.spawn cmd
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    output = OS.mac? ? r.read : (testpath/"out.log").read
    assert_match "PID", output
    assert_match "CPU", output
    assert_match "MEM", output
  ensure
    Process.kill("TERM", pid)
  end
end