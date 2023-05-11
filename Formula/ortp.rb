class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.58/ortp-5.2.58.tar.bz2"
  sha256 "9f35c366161042e300ff153161168efd63c9cb04cb8f393c69ab739670daba72"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f7a7ee78b70910e43cf90dceddff624d483f739cbbbf58d03cf799f8680502b"
    sha256 cellar: :any,                 arm64_monterey: "7cb73a2ffa3ec928439b6eb19dd98b025b375f5a62d977c25174fb1c2aecf4a1"
    sha256 cellar: :any,                 arm64_big_sur:  "2b81b5a6e4a41d10bb891512de1d12db0dcfb5126365284e1fd921a5056ef263"
    sha256 cellar: :any,                 ventura:        "1300344502ac840615c2da796b71595a25ed739149b06c83962481243a6d9cc7"
    sha256 cellar: :any,                 monterey:       "b84755062140cfd9dce9c4ce238e80a4be4f679b8af0230dea3a9d40547af4c8"
    sha256 cellar: :any,                 big_sur:        "9284ff93e052951b6c6dc2eadc7f6411c1ac0a97e6ec7bf757f468d0dac144cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3bfabb071caa3e8ca30d506895f86c51950bcb48e3dcbf91295c8f95d2bde55"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.58/bctoolbox-5.2.58.tar.bz2"
    sha256 "6060fa14c73b8fe35b4728bb26dd629668948cb29c3e51a8db75aa95b5c65095"
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