class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.89/ortp-5.2.89.tar.bz2"
  sha256 "7eb1b51186ec79952fbc72379beebe212eca7a145de944f7c793962192362ff6"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b5298a8b622ef618fefaae307bf5a3fefb95d9cd23e7bf64f14d21ef2959ad8"
    sha256 cellar: :any,                 arm64_monterey: "31a23300cbcb9b14b498d7ff98907884e111c5d52e62a2be00ae3bbe6bdd2c0d"
    sha256 cellar: :any,                 arm64_big_sur:  "5fee5652d1ccd7937a2b1e7d5f5045931ffe39993fff20d9f957485f957d0a04"
    sha256 cellar: :any,                 ventura:        "449fa317d82c4e01951ade07a26fe1fcc779693593af5b3eb6599b37c91eb5a9"
    sha256 cellar: :any,                 monterey:       "1b59763386a68ce8fc7aa1f101ef246b4c6ad4280e7502c9effa935beecb98b5"
    sha256 cellar: :any,                 big_sur:        "aac6bf660f69ad418545d5205930f41f66d51539dda04b17479f1057e44d4e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b36ba7adc11bf542eddf21790e8d82560fe5e9025dac992eb153e3d98c9ec29"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.89/bctoolbox-5.2.89.tar.bz2"
    sha256 "76aaf9a9f0695d7b96e548be886b824dbeabf1a5649e6275642c917902c7b2fa"
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