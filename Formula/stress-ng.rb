class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghproxy.com/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.04.tar.gz"
  sha256 "92922b979b5ca6ee05b03fd792c32a0b25a01fea6161b418b5e672c64ffb549f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9956e4b110db869265208a78ef18c49f273d28e8867a53908fbdde79047337a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0183ce0d035c39729ab2dd27b4524611babe6f548268bae73361f5a8c7eccfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcbf6bdb9b2fb95fb671390d3d41c2a26af18776bd7bcfa0e26778aa32b016da"
    sha256 cellar: :any_skip_relocation, ventura:        "79c732c09caf2652ae152e15257e4c0b92f11d1cbb307291e0f42d6bdd094b52"
    sha256 cellar: :any_skip_relocation, monterey:       "45a757d3fd120cc356738c025bc7de7fd835d55011246b9eaea4b5f0e5c67c83"
    sha256 cellar: :any_skip_relocation, big_sur:        "e853630d5973527b7dba1f5114addd794f264c741981d5ead411a009275e90ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0f9778aa3d1b4dbc32cadbf337774ee45d140eac84c1f58b245967f5603040"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end