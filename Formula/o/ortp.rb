class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.102/ortp-5.2.102.tar.bz2"
  sha256 "d7a270d502009a787c5bd53ca9db8cc52a714e3a014f23944d4198efd3c7e4ee"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4515092a287fec50fdaca63a031b5dbeae4b5e602e41b9cf45fcbc9ee7d460ad"
    sha256 cellar: :any,                 arm64_monterey: "91968bf54191c9c975e9e504d4d53b1a56a1dd031bdcbd0bc7e005d5621c5288"
    sha256 cellar: :any,                 arm64_big_sur:  "47a602350b583415d8ae373ecae17ad47df8dda2a4fff85453765534f223dabb"
    sha256 cellar: :any,                 ventura:        "3351fcfdb1f312ab7a9c3bc0f944c5c03b5845f138d1c8cc341e05ed830f496a"
    sha256 cellar: :any,                 monterey:       "457df205c1ba963f23ccb1b6ea423d68edf74f3a0663cd5a3c9848bea829b437"
    sha256 cellar: :any,                 big_sur:        "64580798f3f34a5927e1867bca386c4d203abc17338c24dc602af713abc68157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d85bd59c7bac3934c69571ed12e1064a7e5402097eedacb5a3648366d653de8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.102/bctoolbox-5.2.102.tar.bz2"
    sha256 "0b6287d89780b94866b879c09504a9f90f3dceebd5536303e700042a4b254c4a"
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