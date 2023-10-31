class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://ghproxy.com/https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_1_2/ACE+TAO-7.1.2.tar.bz2"
  sha256 "9910d1018d73db91c89affd20c9b9fa2265aa8e5b42ea4fff30bfb4a8e7d313b"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "955af994d20b3e2eb0735fae8680941e6ec02d24dc3a41903a8ae5b87991a98b"
    sha256 cellar: :any,                 arm64_ventura:  "a2e675bea9986d49fd636c6a66e31c1fdb2b06781c29381578f0025458f935c1"
    sha256 cellar: :any,                 arm64_monterey: "1b04dc5c7943fd12f0d0076b26a89955ab68f065e9696d8c2d9221e942afde8d"
    sha256 cellar: :any,                 sonoma:         "1c248c74e67f872d8c588da8e5dfac8bcabb493c05e983341f763e67e6db4368"
    sha256 cellar: :any,                 ventura:        "f258e6f1304f9af5a132760044d7c16dce5561f31dfc6d8241ce7dce2fe86556"
    sha256 cellar: :any,                 monterey:       "7a55e038dd4555fd0801c95ecd16d4cec8ea8ae9d285f7b1665c3a7d7e19d97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e6941007857e458f1bc345cb32116d47d506b14dde90fe9df2eb064ac772cc"
  end

  def install
    os = OS.mac? ? "macosx" : "linux"
    ln_sf "config-#{os}.h", "ace/config.h"
    ln_sf "platform_#{os}.GNU", "include/makeinclude/platform_macros.GNU"

    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?
    system "make", "-C", "examples/Log_Msg"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end