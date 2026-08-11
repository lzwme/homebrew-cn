class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://ghfast.top/https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.508.tar.gz"
  sha256 "252f716bbac57d0a665a0c087f18abab095acc8369786cd08d1dde831ecd4747"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a27f9fdccd0290d437eacf1108c73ba18768d90836fd0208ee4521a6ff4728a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5ee0bb4451f27e0900220856a949dac43131698af3f4cc85964d28305dc268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d239d522b4c39b44a9c313c8b511d640eb38927b08b8c5918ebc2e2ea1d2e26c"
    sha256 cellar: :any_skip_relocation, sonoma:        "43059d0a433087016ce8bc31560f35596cf3f3e0a9c76c49dd1866a0934bb904"
    sha256 cellar: :any,                 arm64_linux:   "0e61ab994f9a71816f69e12da71aed42f2d9fdaa91a7f154d770de716b23db9a"
    sha256 cellar: :any,                 x86_64_linux:  "40ddfc156749ec87f67a57e79022f021862fe406cea573fbee626187ab6dae0a"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    os = OS.mac? ? "macosx" : "linux"
    system "make", os, "KFLAGS=-DCK_NCURSES -I#{formula_opt_include("ncurses")}"

    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    # /confirm:off keeps this headless.
    system "#{bin}/kermit", "-C",
           "set host /network-type:pseudoterminal \"kermit -x\", get /confirm:off /bin/sh, bye, quit"
    assert_path_exists "sh"
  end
end