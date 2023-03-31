class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.45/ortp-5.2.45.tar.bz2"
  sha256 "6caab4753f0e8ad22fbbd9e0e9025f32c7e190ff3cd38c42f3d421c0b5c08583"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84d0682f3bbf627e85415059d3ed68e8886387c8359618434a97223e8a09df8f"
    sha256 cellar: :any,                 arm64_monterey: "f3a618e8e3c877918a535f4297a0ff131d6e9421bdcfc1300a9b4c7932272d1b"
    sha256 cellar: :any,                 arm64_big_sur:  "8d62160c2da7fb5160c9888b0b39fa6ac8f51853cadecb058f3cb15acc6de676"
    sha256 cellar: :any,                 ventura:        "ec38cff8dd0f84d1cfb7be33b676bae1b678a753dd2f17aaac6f105db7dcda80"
    sha256 cellar: :any,                 monterey:       "2973447826f1f98b70a478dccba3c519111cdebe817e3dab777f102e516e4a2e"
    sha256 cellar: :any,                 big_sur:        "7ca32f4fbc5f634de22489b3e50c421d78d856846f632c0323642c0b8f9eefb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05daeefae08a68dff19c26018c3e6fd164a05c68a95517c35ee100cf9fb6e650"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.45/bctoolbox-5.2.45.tar.bz2"
    sha256 "ac636f9e1c2187643357ae0d739d4c60b3453f29bc28e0ad18cc00d2c1703704"
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