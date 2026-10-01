class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://ghfast.top/https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.514.tar.gz"
  sha256 "f7f7e0b937bee12aef21467b8b5afa7195a5697b523645a412c3a3c57a085b5a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d44618d8432b4c470454a472865814c07f5394aeabdfa9ecb8d289609aadf73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42c1ea50a04cfb8d3826fa5f4d19543787ac16720d7b6a16abbf2e74b3864af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57ba5ead9f46182439662bd28421d926a5ed432c2792ab1baee3599395ece4b9"
    sha256 cellar: :any,                 arm64_linux:       "10b547991087abcd68ef8d7c55cab06fae7876ebfca24cd97ce4e81ffbd3e6be"
    sha256 cellar: :any,                 x86_64_linux:      "0c503c1e124883cb0207f60bad0168dbb9b787f1b24f7720a3a7127d4b512f60"
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