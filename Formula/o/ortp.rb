class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.106/ortp-5.2.106.tar.bz2"
  sha256 "c9a3b50c1db526f24dfaa0d3f15344688aac4d98a206df3639e6026a0195c9ea"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5515c72ca908120d557b1b1fb8ea2045b57ba36dc4e6317214d5eb96ad84931c"
    sha256 cellar: :any,                 arm64_monterey: "a2936dea7d7bf9658d1d11a65c4a52be2f34f41dcf736cd5e4f6ad2fbee259b8"
    sha256 cellar: :any,                 arm64_big_sur:  "f5c462fbcb2c731d09610fd23b1519f8084431ca0005f6b92ebb9e4cb40b29f3"
    sha256 cellar: :any,                 ventura:        "1ed2c4388323b16dd4a0172119dd25c3b1964708899cf6830d0c328cdca3cd12"
    sha256 cellar: :any,                 monterey:       "f81860050a02e3dc02800f5d5a844e4cfedabf94ae8c3d887030fcfedcbf9908"
    sha256 cellar: :any,                 big_sur:        "d1dc891e143fbf1b06b03c701dfd24fc6569c347eb96e52e2ddffed382109836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71dc7c466d370b3bcb773ed939e9ff63be9454e8b078c5ace40b7374a9be1b5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.106/bctoolbox-5.2.106.tar.bz2"
    sha256 "3d1722ee7aa4a6fc38d32d512169a013881f226ae63d3aef3fd668e70be237bc"
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