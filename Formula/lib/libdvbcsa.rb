class Libdvbcsa < Formula
  desc "Free implementation of the DVB Common Scrambling Algorithm"
  homepage "https://www.videolan.org/developers/libdvbcsa.html"
  url "https://get.videolan.org/libdvbcsa/1.1.0/libdvbcsa-1.1.0.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/libdvbcsa/1.1.0/libdvbcsa-1.1.0.tar.gz"
  sha256 "4db78af5cdb2641dfb1136fe3531960a477c9e3e3b6ba19a2754d046af3f456d"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvbcsa.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "455b0168a4c59e756200be47603e1090535ab36c9a9550df92b5359375e22e19"
    sha256 cellar: :any,                 arm64_monterey: "880b119027071e1f755479049e7c250ddf240aa7e3b1a70d45dcc5a280e0fd5a"
    sha256 cellar: :any,                 arm64_big_sur:  "dfdb5b69befb37656f00769a3d657644f983c27c2b0ab93708c4eabcc48e9288"
    sha256 cellar: :any,                 ventura:        "6dbe9f5323baa58981e962a837d19357806a3d5ca233f87daf8e606855635146"
    sha256 cellar: :any,                 monterey:       "bbda0b438d4a659c99d2f23fd706db9fe72bfacea2394c69e0e8130f43e1d9d7"
    sha256 cellar: :any,                 big_sur:        "478a1dc726d6a48236b199e709f95440083afda1e25aee072ab33fac7f783183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cda58fe30ffc94214d77f45ee2d087a1bf8382c6429ad0bf1dd6503b208e23a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = std_configure_args
    args << "--enable-sse2" if Hardware::CPU.intel?
    system "./configure", *args
    system "make", "install"

    pkgshare.install "test/testbitslice.c"
  end

  test do
    # Adjust headers to allow the test to build without the upstream source tree
    cp pkgshare/"testbitslice.c", testpath/"test.c"
    inreplace "test.c",
              "#include \"dvbcsa_pv.h\"",
              "#include <stdlib.h>\n#include <stdint.h>\n#include <string.h>\n"

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-ldvbcsa", "-o", "test"
    system testpath/"test"
  end
end