class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.105/ortp-5.2.105.tar.bz2"
  sha256 "b2f61e1f7204cbcf6cda4dd7f027494b641de5ccd2efed7b839037e15f7799d9"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd979ac32677404bfc25b4f9739df4e965d8e1e28aa008fc5658166facdb74d3"
    sha256 cellar: :any,                 arm64_monterey: "7ec61a28e0c7a53b29c6b4705fe1c955c73b413d49cca1815ddaae3b788bebfa"
    sha256 cellar: :any,                 arm64_big_sur:  "f102e0f658826b12fe97e4e58ce1ddaf2d52e2c5bf0d01a798f9cd1e6779c44c"
    sha256 cellar: :any,                 ventura:        "05fc12d397d3af2f4c68d2fcfa5f703200f3be71c77163b9213091797be45380"
    sha256 cellar: :any,                 monterey:       "086246804df0688ac0cda9942722f95b2873981ebe3818259e73e56d27e227c4"
    sha256 cellar: :any,                 big_sur:        "4bcd84421f547ed93793e0941e61db4ec12fc30b2a0dde4ca5498b8b8a1f8fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16d9275e3a2b760ad8a10af2d79359522c35a9c694b6a308318f26278c9682f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.105/bctoolbox-5.2.105.tar.bz2"
    sha256 "81aae758022118133df0fd90f4c06c36f224922ee15e84445dd737294e0a20b7"
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