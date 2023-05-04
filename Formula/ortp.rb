class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.54/ortp-5.2.54.tar.bz2"
  sha256 "2955add71313d66ef4443cbfe1394c79a25fb8479b04a64603830a2515f56de5"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d3923fa6c540460bfb36455ecb99c0178a1b67bd2da1e07e0efb2c2783597e0"
    sha256 cellar: :any,                 arm64_monterey: "0e3114f1f2b43d14196a7c5753e1607cd92a2e50b0fa07f2b944f38bcf47f7b2"
    sha256 cellar: :any,                 arm64_big_sur:  "d3c3919631987e87288dccf21fdc7ae57f39188ffa88e1a0484e5fc096c2a18d"
    sha256 cellar: :any,                 ventura:        "1d555158015aac5fe229b8277dbf9310224c9d85885610bbef2e5ae971749d11"
    sha256 cellar: :any,                 monterey:       "23b96c897ae2541c29eb50623ff425177388421057764933b374e4c80ae91c07"
    sha256 cellar: :any,                 big_sur:        "ea18cfb1d74fbe1186f7cd53379406e4fbdcac44cd10070649680f826d8725dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72f4eaad8337131bfdc8546569cf266abdf973c13261cd2d4c3d234d488043d3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.54/bctoolbox-5.2.54.tar.bz2"
    sha256 "9a890fcb66b45c3dc1f1b3ef572535babcc7751850fdefa5b837c4fd7bc8e41c"
  end

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end