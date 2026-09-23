class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://ghfast.top/https://github.com/kyu08/fzf-make/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "41587f1340cfa440491704a0edbe945a0fe7f4965c09ea4cad84580ab7f6f937"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "894357124f3f5ae426e842fde3768b579f7a86f914f90682b3598698ba2dfc43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c13b7667840265e01971ee7216b614a5d62593bb5bb3806781ccc59aac002ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c529f0e31b7aa1c62c7ef4fb12872b9270a895e7721bd31a6849e945a6d6853"
    sha256 cellar: :any,                 arm64_linux:       "17c3a68e5fc2c3c992c53de8a4b92c2afa8c6d5668899a8a482be274dad07c03"
    sha256 cellar: :any,                 x86_64_linux:      "3f23f1d70373c58901afdd69edb9d3e01b27cf30f1847747bce08cf44c2bbf3e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/fzf-make > #{output_log} 2>&1")
        r.winsize = [80, 130]
      end
      sleep 5
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end