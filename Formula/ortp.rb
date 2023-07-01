class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.83/ortp-5.2.83.tar.bz2"
  sha256 "cddb3e2fa4d1c7126dcd6070d3ea2fce4cabdbbaf6480aca8c806e6c312bd431"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "94c0f6808ee837013c46059a1c76b5b91adab452ab8783b933f8c79ccb4f6d08"
    sha256 cellar: :any,                 arm64_monterey: "ff5948428ce8bdbf258fa3bc6c10295acafaa766fdca50ef902b00a5435ce678"
    sha256 cellar: :any,                 arm64_big_sur:  "6998d3f5693469f017c35fbc591a67da124a8746f01ce5263b70c6b4f8f5ca43"
    sha256 cellar: :any,                 ventura:        "e9ba1053bf02a7abcbe8aa0d3aaa666db37f2da7d740ed59e7460e70200f512c"
    sha256 cellar: :any,                 monterey:       "3d51eac5a585080683a767350249e2217e34c85c9780dd8890e3dea90a6f6b63"
    sha256 cellar: :any,                 big_sur:        "2691aad3d62f3bf3f148f36d1424ad5091ba6f1f35593215a5ff486983fb3316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4286cc8586b0a7e8143eff4e5e18a032a6893cb48122aeb324c0f23a189903ce"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.83/bctoolbox-5.2.83.tar.bz2"
    sha256 "8e2639ecdd733efe4268201a45a68b03f5e82fe212c4b5da4d9dcfbe534b7157"
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