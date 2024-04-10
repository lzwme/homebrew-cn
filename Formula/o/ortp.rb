class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.41ortp-5.3.41.tar.bz2"
    sha256 "f293eba6e5177002a7897e23501f578f542887c71895c9a2f8d305ff9b31853b"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.41bctoolbox-5.3.41.tar.bz2"
      sha256 "91937eb0943a3e0a362d5b5d924246b59c9e41f6d9d17a1b41706f5e03c87662"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4490556d1fe31bbbd37a4effef2ad2c791c5623c0b77f96325e36cda4657e877"
    sha256 cellar: :any,                 arm64_ventura:  "3c3715341e2c5d3bf3daf607503cf75543bc6c1d2734e00263912d81eda0ab0f"
    sha256 cellar: :any,                 arm64_monterey: "e3480e08cfb3daf375248ff4cdc1ff0a38ec945aebc7968b7759f091fe420629"
    sha256 cellar: :any,                 sonoma:         "d09c4ad1212328b1e5d688c73f825142e9573bf5347a16b68e2e2b4b92b1f356"
    sha256 cellar: :any,                 ventura:        "146d2f9865d5c0ca2240233230c5450c34fb76b586a3577e1399e15b27a0ec33"
    sha256 cellar: :any,                 monterey:       "9eb61f91497a13f58af62d7a3b6d68d01fa169f2ef242133dedafde84950d1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c446753b15290e774c195732a0c1e7c72756ca6d522f9084e3e989626f3a5e5f"
  end

  head do
    url "https:gitlab.linphone.orgBCpublicortp.git", branch: "master"

    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF", "-DBUILD_SHARED_LIBS=ON"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec"libpkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}lib" if OS.linux?
    cflags = ["-I#{libexec}include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}include
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include "ortplogging.h"
      #include "ortprtpsession.h"
      #include "ortpsessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}include", *linker_flags
    system ".test"
  end
end