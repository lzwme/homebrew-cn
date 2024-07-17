class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.70ortp-5.3.70.tar.bz2"
    sha256 "eeb2cbc814a9825bc7c3df414be6b10675b3157448656033918d606fe16993ee"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.70bctoolbox-5.3.70.tar.bz2"
      sha256 "9db8db01eebb1ad7c44ee3a0cbf8ac50989567b9d2f1a87b721cd2664f5821a4"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53ef5b2f3665f374eb3d492de6269bf032bee9eef3ea89098f45641d6a118666"
    sha256 cellar: :any,                 arm64_ventura:  "b22da2d6685ce2b97f021f9307329c587a7cce75c780cfebd90759685b3e8575"
    sha256 cellar: :any,                 arm64_monterey: "dcfad17cacd4b762794395812eaf7d31fbe80cb58db676c8df9458f4062921b5"
    sha256 cellar: :any,                 sonoma:         "f50397684641629273613208d515490717eca4ac9992a37fefc733fc7c55e78e"
    sha256 cellar: :any,                 ventura:        "bc7ce6f321e664913eab585863de69bcee2df5ea5576f043fec92e1fc6dc7012"
    sha256 cellar: :any,                 monterey:       "5626f51d8b137b33c2c3ab93c0f053ca7c14a871896df8bdfda65fe751ca263d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1e9ba8dfe3998c7343e2bf26f4a766169da139d0c3dd3c7045fc8fec93d11f6"
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