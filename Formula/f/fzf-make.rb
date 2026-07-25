class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://ghfast.top/https://github.com/kyu08/fzf-make/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "c6294d55035bea91b19aa0e87dfdceded9da43f45e6d83f07c2d03092ff6b699"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41d53588438b3c8b04d24909b897e55feee1084612306e8b34d94467ba8c9fcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ce31c55c162939d99883b31c1591d394111474c23a885c239af215fc32b418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c367b1a22862b53a6e37e0d0bfc2fe63ece9ffc221c9c9b4f94a50d1e11e1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4fcfe021becbde708de5b3742f1e7fcdcdbdb73e924c470839958f71fa1ec41"
    sha256 cellar: :any,                 arm64_linux:   "743ce56b4d9b44973034df422674f43f274686cea728c7869eb0f925e0f779e0"
    sha256 cellar: :any,                 x86_64_linux:  "77bafb2a5eab45f8cc51942f10d9adf12a073046ae57bf65b95902e6d52b1429"
  end

  depends_on "rust" => :build

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
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end