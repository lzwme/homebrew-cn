class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://ghfast.top/https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.507.tar.gz"
  sha256 "45070b3fb0f9eda87e8a3b9126b110aed8fe4f561bf803e4fd856dbc367d9b0a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f48e712b68a2219a9eba05e315794e6b18edd820ebfe35a23545d7edf3683514"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beec8350f4960e99ced38824f7ccdcb402474d4b30099ecd84582172602e33e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f4d490727fad30f1072d6174014afcd495b758d1d3b9049e139eb8283d708f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b477a9348fda209c4f17c0a59e0045f5ee38486e36549c5ecd32b0b9c4479b7"
    sha256 cellar: :any,                 arm64_linux:   "527505ea70b6864ad964c484099dc3293ee2ceae5a3f029fadac1516d6f8a08a"
    sha256 cellar: :any,                 x86_64_linux:  "75d2c3bea63f3354ab93b8c40bd9ad302f9f8b441e0ea43fe900522ec8120952"
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