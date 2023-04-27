class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.52/ortp-5.2.52.tar.bz2"
  sha256 "3a059872f8e609efb249c8172a11e75a75c4391206007d22e83c059d7d360769"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d502cc4b679d0fb82063f54e59867aaf3583c3082904d6250ded35034cfa137a"
    sha256 cellar: :any,                 arm64_monterey: "091af992854f9804f5c61f80bf0275277c9952d332dd8d5d2ad9a221e0dbb68c"
    sha256 cellar: :any,                 arm64_big_sur:  "13b952373cf38ee67f64296d388148e94ff29ca9b28cbbac9783ead965e51456"
    sha256 cellar: :any,                 ventura:        "7c1b97cc258b80927934099d9e51654d9e6b1b6c4154f262c3770a874b3c2d35"
    sha256 cellar: :any,                 monterey:       "46a6b60846d10bb18134fc7d6846c249ad0509737ac4c4fc0797321f891619d5"
    sha256 cellar: :any,                 big_sur:        "d344976e33bfec8b3b57a47fccdfcdc056feacc96af9121fffa9386e3d94d00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1332a44c0e436595214685d9bed80fe59e683ce1c9c93ea266dfaa49ae3e489"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.52/bctoolbox-5.2.52.tar.bz2"
    sha256 "27082d613ce175cae3a85ef890861f8314f80370f48250b1cb12d24c628dea18"
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