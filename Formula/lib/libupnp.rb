class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-1.18.2/libupnp-1.18.2.tar.bz2"
  sha256 "2d0efa0008940de31c139192564db1ec6ddaa4b4638a5bc4424f12901cc7e1d4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0f610df69e91ee91eb638640b1ed02cc05e14a5fab66a89c940624c1756b712"
    sha256 cellar: :any,                 arm64_sequoia: "46fc2781cf2860f700b5964718e9f56dcf2020e5bb44a9fd50e810a0847e4bd3"
    sha256 cellar: :any,                 arm64_sonoma:  "0100eeb602c5e83f2ddebfb68c57bc211daefcb23a7e38474b8d9bec8737d74b"
    sha256 cellar: :any,                 sonoma:        "cb03657dbf8008551c4f3975f373c95fbb7e26b48d2ce7a61a3cc44d75fcbbd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "570ff029b8815ee1bc0884c0a14427b03a12d1420dd9ffbf1573473cc3bc3643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6328071c528f6c76e70448481f6f464f0144069fe033573345409f47ecafe68e"
  end

  def install
    system "./configure", "--enable-ipv6", *std_configure_args
    system "make", "install"
    pkgshare.install "upnp/test/test_init.c"
  end

  test do
    system ENV.cc, pkgshare/"test_init.c", "-o", "test", "-I#{include}/upnp", "-L#{lib}", "-lupnp"
    output = shell_output("./test")
    assert_match "UPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end