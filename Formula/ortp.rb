class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.93/ortp-5.2.93.tar.bz2"
  sha256 "25c261935f247566c67dda6457e02a3f18f53113241a6160e21703ef4a09c9d3"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e72d53d67e3f17faf691fb14d59d940fbc99112e99f376233542e3c0bcc0e345"
    sha256 cellar: :any,                 arm64_monterey: "7d68f1f3852b4bb2e214e9178f0ab5ccec738248c2882a8fe08eb0eafc732991"
    sha256 cellar: :any,                 arm64_big_sur:  "9ba7613a44e5a17e9d52af660c67c983f9faf349deb0d36afcc3f47c50419de2"
    sha256 cellar: :any,                 ventura:        "2459bce452d82b6a4b3d6f53198cd8a55f9e57cb1ac73b3a2511d75650da7cfa"
    sha256 cellar: :any,                 monterey:       "3a80bb75d036c3417f43c78557b809258fec2829f58a1ff2afa04b66eb970591"
    sha256 cellar: :any,                 big_sur:        "feac736c82b44f89e48b1b8be8bae3a7d8ce2783bed245c42ba24fa3eb11965b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70595d42e563c6d8d7b1facadff5a5f31a793702ebfd4ddf923079ecf3b16d9b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.93/bctoolbox-5.2.93.tar.bz2"
    sha256 "e166ced129e32a470fbd73ee1bfe8d76aca109d9186397d9d9dd566428f2eca3"
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