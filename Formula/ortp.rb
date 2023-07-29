class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.94/ortp-5.2.94.tar.bz2"
  sha256 "b210f5f38b89e958e0c540caac56565b5eb5ea0e8fb291a379ed7aa72667d4b4"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36e2b738e0b037adb4b5a2ccb5469477db7e2c320810cdd595de5b55b7663e68"
    sha256 cellar: :any,                 arm64_monterey: "d188a43fc51709526b69fd488200f8fcc45ac35b1e62b671c917db3ced9e44b8"
    sha256 cellar: :any,                 arm64_big_sur:  "5bb9b542d2df3172a30638c473a4549ea814d365856aa525e880832b44e87f41"
    sha256 cellar: :any,                 ventura:        "9b1ab22f8c405d4643d5516a2fe9cf1701eaae811d8336caf01c11b5b0b62076"
    sha256 cellar: :any,                 monterey:       "4224bcd1beb32a0c4fbefc937b4375df4c76298d4d60b7dc881d3513871b19e1"
    sha256 cellar: :any,                 big_sur:        "aad7921785fcb6b67297d2b58fd77a8b5a14d1ab2fc94af9eb988059f411dddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b8b46f6f9608132f7fd148977b856cb5a6e3cdcbbff05cbd2608f05862c4da"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.94/bctoolbox-5.2.94.tar.bz2"
    sha256 "d4e81d6e7aeb19e0d2bb4f7aa0645273469507cf1f3ab66ae742f39944cd2503"
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