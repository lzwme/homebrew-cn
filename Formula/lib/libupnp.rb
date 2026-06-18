class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-2.0.1/libupnp-2.0.1.tar.bz2"
  sha256 "0887c4d54a12aabf0ffeea04a8ab72202730300ea51828c0ed540ffdedbaaf48"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "301fd7d2e9458b33ad76c1bdcbc7f782c82fecc92d2ad5ca092de93478afb63d"
    sha256 cellar: :any, arm64_sequoia: "0b0d787932ce28334accb99cac9afdda98f39c25e9ffe98a1fc66626964850bf"
    sha256 cellar: :any, arm64_sonoma:  "b3640244ed0e7a878e5b282245d556d1b98de4f99817bf979c35bb4029bc2f54"
    sha256 cellar: :any, sonoma:        "6103629c1583852852eb42f5c0edcb2e1aac5a476002ae0215b472db187e9042"
    sha256 cellar: :any, arm64_linux:   "feab356adf0333bcbc6099504cb3f46048e20430293a3180ca6c883fbd552f6b"
    sha256 cellar: :any, x86_64_linux:  "fa0b36c64c6a2468380fa6ab8c8137cf01e8b96c076a3bdc399b6ad48dea2dd8"
  end

  def install
    # https://github.com/llvm/llvm-project/issues/65557
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "upnp/src/genlib/miniserver/miniserver.c", "switch (gMServState)",
                                                           "switch ((MiniServerState)gMServState)"
    end

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