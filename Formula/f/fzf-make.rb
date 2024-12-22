class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.50.0.tar.gz"
  sha256 "8f8f516025ff0ef61edb48b1a4f4c578e7560eaa3320aa398f9802e6f6fb6800"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb04287b237067a8da1bce449321266dc6b04fa1714c863eecf6e713b1f78c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6071f181fa42bbdbcbc98528d48c5ecd9008f5015703e404ae2120330c60534e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9945339416a0c3cf8831b40d4fadb19a7c82a80f02a404ca76a14a9add073c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "14cda4b4ca2df8d0f51e54a94c019db4c00f583fdeae793593b73977cbbb987d"
    sha256 cellar: :any_skip_relocation, ventura:       "9d149c90e8e3c0c04fcf4b8377dd7f5e6c372b5464e53978ea56999fee0a365c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a081564d16b5e8bf9769e72a241955c3c479178cd65cd7389bbefcd2bf6d0a1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath"output.log"
      pid = spawn bin"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end