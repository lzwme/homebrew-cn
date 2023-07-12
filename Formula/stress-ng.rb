class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghproxy.com/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.16.01.tar.gz"
  sha256 "3bda6f16f2c215bd46309d6b9134889babeb0bb839a9cc0786f0b453a1c8e975"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a46d3e33addd615fb6b28ed3e832e077d5b585c259706db964c60936e14bc42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41617e4d1e05f7825dfdf68572be2cd54c6d015684e9dfea9104ca15f00e98da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285c81662a0c191db622b1de8138a52229912c4729cd6792dd88e8591be1d621"
    sha256 cellar: :any_skip_relocation, ventura:        "b23a0fd29ede359ca8ab0b8a9f8b7109d96d7cec2356c5603c6e88a27c57d45e"
    sha256 cellar: :any_skip_relocation, monterey:       "52e46536668df1be1e9cbd4640bf5da588c0ee8c8b238a71210ea6e1cee14940"
    sha256 cellar: :any_skip_relocation, big_sur:        "f871a333fa3b896f40c992118284233a4321de5d214f90de2d6923ea2887e322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb2b61a90a846523b74811916e0b81b7793d230b8d53a2468190743d79f2744"
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