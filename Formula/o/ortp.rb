class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.97/ortp-5.2.97.tar.bz2"
  sha256 "402d3e973059c54bd3cb4dcbc88528bd448236a8c7a8cf166f22b6e2357f8650"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "efe15f589baaaf7917831f2401fc64d6076480d40bc7a41723ecaa0126e942dd"
    sha256 cellar: :any,                 arm64_monterey: "97f447a8f6c6af91130c2a1c08f59997c6c26df27b5ef74d34e9472d00eabdf0"
    sha256 cellar: :any,                 arm64_big_sur:  "54f1f12fa101578465904b6d5d913de269596d2a99487850f4f881a9d268f4cc"
    sha256 cellar: :any,                 ventura:        "79afe7f4e2873f8a9664cdeacf38876b375d1565c5af5d495b5b43c5fe3a5da8"
    sha256 cellar: :any,                 monterey:       "5f64b4373d3b5d7258b330f08d56b32a19d7c8b5d8ccefe11850b1f6381aa654"
    sha256 cellar: :any,                 big_sur:        "6abfa05f588fe45c4a054fd72d531299f3ca6a6f9a42d3e4e71d2cc1f51e5de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161f0880b7ce3671fc403a8d4572339b83fe25328b6c7e9e4727cad77fc91fdc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.97/bctoolbox-5.2.97.tar.bz2"
    sha256 "46e858da3fa499af215d0cd70477b04249609f456a0869d7acb8a1178e909b60"
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