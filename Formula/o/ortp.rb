class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.71ortp-5.3.71.tar.bz2"
    sha256 "915fb9fe3a6259246c14df1391943668ff887d323042d9802de4277290414bd1"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.71bctoolbox-5.3.71.tar.bz2"
      sha256 "763101877fa5d3a357e608e04e23ad293357a6257534ccd74e311933b17d2b5d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c6fc0f622e1d6400ad5c4f0588819bd9f7c99890a8d0c39787c890cd49e0050"
    sha256 cellar: :any,                 arm64_ventura:  "33eb8ca1f77b217212ac68f804ea330d1d27ec2bd2dd239b8d0e6f6042611d5b"
    sha256 cellar: :any,                 arm64_monterey: "194932714d1069bb601774da31f6c513f74f63510fce7a2cfedf816a50e32a06"
    sha256 cellar: :any,                 sonoma:         "d109adc8acf8533df75670fcd35e0c7ca7368c00a4a7e4da2dac84c31a4991ce"
    sha256 cellar: :any,                 ventura:        "ef0b6867dbdbd2377ca2b95459c6ad8c6261e0cde8dbfd2b523c7d954554f772"
    sha256 cellar: :any,                 monterey:       "438d14f059b295665d7872b8f422c30d4a7d87b3134428dc9995af1424d1aafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65c5e38f619e5635755f666cfd66b471ae10ef9a57ab22550793268b4714f64"
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