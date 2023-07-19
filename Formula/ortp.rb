class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.91/ortp-5.2.91.tar.bz2"
  sha256 "6486321b9bea26082f2a33de112de2b80ec10660dcc146f6c0f0c8e9f9ca8757"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "78f703a03ebf0ef0d7050a7fb08970a27c22e1c0f61102c5619b700bdb0cacc6"
    sha256 cellar: :any,                 arm64_monterey: "590e99b192294e30427e1cf6d40ecc6b340f6592a41e1944928959459984bd8d"
    sha256 cellar: :any,                 arm64_big_sur:  "a0893a53fac40b03b99fc62afeecad392dea9b090516d122fa0711c40d4c82d5"
    sha256 cellar: :any,                 ventura:        "47ebfd7a16b62de3192e62d29e1ca6f7559e7f39dd1c6cfd2f5c48131f301e0b"
    sha256 cellar: :any,                 monterey:       "5f4d39dd55bc9a1f0b2c397417b633ea70a8d0606a9e198e8c1f105883d2247e"
    sha256 cellar: :any,                 big_sur:        "6709953a2d215315e61e325208165e103fc59eff2ba95d6d331c1acd92028360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26daeadaf74a415a4b72352599013db1014d7f4e5131943901fe415f217185c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.91/bctoolbox-5.2.91.tar.bz2"
    sha256 "ef86786325d50ddd440bbb65a4a57ae2512ebf2adf3a7c3ee3b9e0e3bfcdf753"
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