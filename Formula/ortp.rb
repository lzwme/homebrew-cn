class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.29/ortp-5.2.29.tar.bz2"
  sha256 "53a65d07a7c5c62721624d96cf265ca40bece5c4da67c78bd1e3f6aa7af70f71"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe43d97333204b5367f2b81595000fe40a8d69bb786d397150b8988cf5e147dc"
    sha256 cellar: :any,                 arm64_monterey: "21b7d17a3d1efa3b4b8189477fc3e6ad98c2679a042c5409d74d06e529130d13"
    sha256 cellar: :any,                 arm64_big_sur:  "eb86cf48e6241770ae169a365f9a7cc7f94e62cea9f940bba10f8cb43a49cf6a"
    sha256 cellar: :any,                 ventura:        "ee4affa5199eda4aa32d8e745efb5a6be7c74b329659f7a649474b58e59d7ad8"
    sha256 cellar: :any,                 monterey:       "ad63397afe4e65f4d3e2928f0abb01c63bca2da4efb7357d4ff21ec703b27355"
    sha256 cellar: :any,                 big_sur:        "663992b51b3781be89ddb4781934bb183d9114591ee130418f8f80d3b8eedba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade87fb460b3774613f302502c7cdc2aa8e55002ec8e0e90ca0e901d64410672"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.29/bctoolbox-5.2.29.tar.bz2"
    sha256 "bed1ff1c2cbae57f9a7a75d9ca2a25b58f5bcb7f758d4e396fd73b5c0f6934f9"
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