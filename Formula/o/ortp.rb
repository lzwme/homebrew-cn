class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.22ortp-5.3.22.tar.bz2"
    sha256 "7ca41e50d17b794c59631950133e1ade0125bab705b74159837fa7e8f6fd1e44"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.22bctoolbox-5.3.22.tar.bz2"
      sha256 "fda586c0a545e6db33c63fececf5b6b0e37953951e7b17a6ca6570844ac65f2d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a8e1c249e7b2c9bf530ea58f95e5f29fa9e3f2838875592019297cb3544ae35"
    sha256 cellar: :any,                 arm64_ventura:  "b917c395f640fcb63e8606afc4126dd05a25007c61daaeacd96544d95479bbcb"
    sha256 cellar: :any,                 arm64_monterey: "b21bd14aceb9a757ae3a35b2897103cfc8f789e22fe076eab6bff583b621f2c0"
    sha256 cellar: :any,                 sonoma:         "8083c1e66b878b3156c2728a70ec1df1fceec2c21b21bfc06264c2f3b09d5ac5"
    sha256 cellar: :any,                 ventura:        "5086eb0cfa33f8909eac93517d5b8a6f79ad5e5220101fd0773ca47a397b37eb"
    sha256 cellar: :any,                 monterey:       "a17b1ec2b304ffa08ad6ae3058768d91906b8a4eed39e9aee19a0cb3ae0b6f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cd44e16bd75b0be994dac008ee8dde70238cf320c006055ed208c3daf294359"
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

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end