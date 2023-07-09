class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghproxy.com/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.16.00.tar.gz"
  sha256 "f3d99281fe2f9695d627608a3aa610dfd6f3fa6eb1a3d7c457b09ff6defd0f78"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "384193a4918878d3a17f058ee7da5cf20c06ae2eba01f66f7025afe14d633a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f96462945aa432a0e19f894e8a5ae92d7a1981393f3236409b3077e0cefb35b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d265baf99e17178ab32e5f127daa74c5a2bfa99fdfb5083cf5f6124bb3a1abb1"
    sha256 cellar: :any_skip_relocation, ventura:        "8e43ddf342f2c6ae58779355cd810ecac103abdc30499acde9d1d92038f75c36"
    sha256 cellar: :any_skip_relocation, monterey:       "2968da2820c73c4d69e7cd73f0d8635c3b85de09859afa0b9d4fd872fc4ea1d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce59c5bdf5567450fbe8ca3499cedd56e92cdbd98e37a67b69d6df163143a2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc394b87168aaf1a5caa7b0212ef9aa0eabb0f5c5ac2e8362df5e693c2cbcf8"
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