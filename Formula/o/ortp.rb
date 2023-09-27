class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.108/ortp-5.2.108.tar.bz2"
  sha256 "f4f8d0fd41c875eaf060ba6f2f9c5cb4033ba3c41f83db508fde56261b7aefef"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc96a353e0177cc1dc8ec09cc5097c1b82137da49a4b17d688d8af3dd957efdc"
    sha256 cellar: :any,                 arm64_ventura:  "0e5117324478266048407a5a6197416effb80c2b8f2c79f9965eb7053f4685ff"
    sha256 cellar: :any,                 arm64_monterey: "a9019474912efa0e172b8362d87d184eb7ca367f19bbff2331f99057250805b2"
    sha256 cellar: :any,                 sonoma:         "388be7d7807363328ac63680d5ff458d90213905a5c91d34375d8ffe655224b4"
    sha256 cellar: :any,                 ventura:        "d71b2139373c555b8c41dd247e88c3f57f0b548bfec7dd2feb2baf4d2b01ad97"
    sha256 cellar: :any,                 monterey:       "ddc20e676ece47407fa8760f06346d22387849a7f75f14707c6beeb1afc3d583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b086775a1b36bfbccb09a0761553dae3402ed44aec3e7e8105746fce3c98648b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.108/bctoolbox-5.2.108.tar.bz2"
    sha256 "2c21b95aead622e27d1165df12a9dcbb9c128b247f5ca12c6f8596dd79ea7a69"
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