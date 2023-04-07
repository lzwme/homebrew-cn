class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.49/ortp-5.2.49.tar.bz2"
  sha256 "7f27554745fd8a0b0f0136b06e82b67fb051d0bbdfffb4c2f8ebe47d1151b1c4"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "275e5ee5d8f386c13fe44f78a431b6769244770d59e07945b36a37788614fd82"
    sha256 cellar: :any,                 arm64_monterey: "914d246fe989ed2766df34a6df030f9c630848a5ac0cc09822807cf574811b95"
    sha256 cellar: :any,                 arm64_big_sur:  "a4c1f48e1bf487b1708d4d62a8f1a5d71ed7e6396eb90ee435420f93335153fb"
    sha256 cellar: :any,                 ventura:        "b87c9aa7b8ac10ccac0df85786a0e159a0a0dd22fca2f1e68370197f6e218595"
    sha256 cellar: :any,                 monterey:       "0ae947f0e6ce6b57bc97ae4655b3f44d3d1e14e91625b690ccb33b50609aac20"
    sha256 cellar: :any,                 big_sur:        "cfb4f307bcec76aeffd2799b294cedb592bbd7f8c1b2a48c160525347c8bcf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbaa8bb79e4db227f2d86efd6521cb40e9606e2f9bf1503a61f9a1e9a4be8758"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.49/bctoolbox-5.2.49.tar.bz2"
    sha256 "4f4f76624115d0420ee0dfeb4bff51ca9d1339822ebc921c11f040cde3e86a9d"
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