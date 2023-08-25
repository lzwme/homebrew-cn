class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.98/ortp-5.2.98.tar.bz2"
  sha256 "0d5b2fbb110e664f7ea6428deb672dea97e7ca1b93396fdf827db081ed17876b"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d766f99ed5edca9a0a63047f64fff5e3f26a18f7babef0f258f1647d17a64385"
    sha256 cellar: :any,                 arm64_monterey: "f2d1fb46ec1c3d736e87b7c5e0ee652dd53bac08ca32dd37e1d67b1f98c2735e"
    sha256 cellar: :any,                 arm64_big_sur:  "2769ad6b37298876acb875eceb086f8c7c93111fcd69ad912f608460d74d24da"
    sha256 cellar: :any,                 ventura:        "1af7a99ffdc62fee5f343389adb25f9c93004b3dfc788c03e03da4d6d6e1476b"
    sha256 cellar: :any,                 monterey:       "1266774c1588243c4c28d815bbaeddb5bb9769fc8aa9d7f164b1c9d369c7ccf7"
    sha256 cellar: :any,                 big_sur:        "4f9e7b7fdf1a2ecb6c18e77c69e94946f5d6f90b9b28b618c48078ec46096c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea8a6dbc5e788facd82b8261d9a54405a7363b3f57007f966081823e847f742"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.98/bctoolbox-5.2.98.tar.bz2"
    sha256 "5f6ea68954f3d6ef844a215153413ff575f7b12579267a83d926c1d894cc0c69"
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