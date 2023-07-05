class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.86/ortp-5.2.86.tar.bz2"
  sha256 "de83aee5ebd1c8a23d055025e13ae171b1de8969928bb7590eb03707aa896916"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "28ae31e6a738f276d1cba6f791f271aeecfce1842bec0426fe629147b7a70408"
    sha256 cellar: :any,                 arm64_monterey: "78acd5a9b78af63035cc6832d85a6eb168b80c367d133f5bf18a23826a03596c"
    sha256 cellar: :any,                 arm64_big_sur:  "a9dcb33772cf2980d408243e64f32b7d9401c174f74be7bba88e94057aaf85a1"
    sha256 cellar: :any,                 ventura:        "e9add42a12e68cc358f94742fcf78ec78a1640e3619212e2126707e15e17729d"
    sha256 cellar: :any,                 monterey:       "65baf3d847e7f0386c014def27de648fccdbc596b0b80b1b7293b7d067c2ce77"
    sha256 cellar: :any,                 big_sur:        "7973dab29750acac83ac95ccdb8de9b90f7b149b6728b1e96f13942cd0c341c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f00543eec84610e2a8b68fe5b6dd36b717b811381c8a9b09d1840ea91b16af3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.86/bctoolbox-5.2.86.tar.bz2"
    sha256 "1ee729147cc79e33a7f01c7d3be10839096d089733974b22ee1a962c0dfd05d1"
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