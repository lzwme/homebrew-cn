class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://ghfast.top/https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.510.tar.gz"
  sha256 "8be27f47dd9c303a697190fee847e62f2394248752638acc65c26d8a078a727c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3429addf13648c49362d84475061bad9fe8abc73b68a0594ad091a1e9e9fa734"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d50ac411978cb492196edcc76eaf3d8e7dd85597d0dc0bb8c2435a229fb9d286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47c833396f33a69e725b22c1204214329d873d3262c1b6dd89ff6fa009a20da5"
    sha256 cellar: :any,                 arm64_linux:       "e1100f63e42e84fb95985847503034bfabf81b5ab6b6fe88ff3793b5726a15db"
    sha256 cellar: :any,                 x86_64_linux:      "4a0c12ee31c5897e86252d210255d465623ec3a48aeab5bdcb6b663f448bc5c3"
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