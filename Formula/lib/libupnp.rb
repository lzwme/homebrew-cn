class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-1.18.1/libupnp-1.18.1.tar.bz2"
  sha256 "140b8044d403c01a223efa096642b140698d3a3f28d25bb7a8f26bf42b0e4ef0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f64ff02da37da1be2c2dc399542dc736666718a799c87c487532cc9f5874405c"
    sha256 cellar: :any,                 arm64_sequoia: "c408a48a02d5c2b1722351a007ba97dcfcf4f9c66ec2b776d999cbff2367729c"
    sha256 cellar: :any,                 arm64_sonoma:  "de866096031effa54071f5b5a753595f708e10fe45de5fa8c02c3238e23a9460"
    sha256 cellar: :any,                 sonoma:        "798aa974f1df0ae857702cd791dadfc7af0770a3d3c0c48c2ee325b3316cf143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb415fa3d7bc1e518b9da83e3cc08e681b5e329858b0474b509b43ec676d4da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f720edc9a871abe289bd43f3cc66aeb4fb1fea5655ff4cc91ea4bc3cf23c990"
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