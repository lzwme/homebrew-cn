class Dekit < Formula
  desc "Process manager for dev and prod"
  homepage "https://dekit.run"
  url "https://ghfast.top/https://github.com/pvolok/dekit/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "573e9d9ce12d2ce9236fa8979aecdd1edd26bab0ab99f1268c44d7f9b225d345"
  license "MIT"
  head "https://github.com/pvolok/dekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb7e8249fa1ca6520468b3f9ccdeb5a68d2f7b46a4dcd2b1c7f1b414bea8c733"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8a53e93e466c2403d60f5807561c5a7260047090d0d1d7ac5e87645407e94ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66cdd2647bba7740c5ccd84653bee394ab3f31bcbf9fb02c0107ae98d49271be"
    sha256 cellar: :any,                 arm64_linux:       "0aff09820f73153f46bff4dda339b3efc052d459200e4e2c88143f878fa296bd"
    sha256 cellar: :any,                 x86_64_linux:      "75c68343090feb9dabd09232bc6dd5103fc43b7b0b1cf02915544d731ab2db00"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
    # `dekit` symlinked as `mprocs` runs mprocs cli
    bin.install_symlink "dekit" => "mprocs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dekit --version")
    assert_match "Usage: mprocs", shell_output("#{bin}/mprocs --help")

    require "pty"
    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "qx" # q opens the quit menu, x stops everything
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end