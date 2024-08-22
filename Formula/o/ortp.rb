class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.77ortp-5.3.77.tar.bz2"
    sha256 "a52d7c4a284de92d0426cc3e6de1ec7640ce81995860e0c00bab6668803f03d3"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.77bctoolbox-5.3.77.tar.bz2"
      sha256 "b3eb1b4662c0233680a11d24b8c097773b1bcedcbae3f8c27274d809e03219c9"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44f5a1f52a958db2cec3d623a99b6178e33a80ed3d78a24c21281305a3cd3125"
    sha256 cellar: :any,                 arm64_ventura:  "409b7c1af6659b0aa7846b69bb6c04f8de6a9e7779ccbc50aadd591b30e609a0"
    sha256 cellar: :any,                 arm64_monterey: "2c911c8ba263eabde47fafff5e23bfc710fa21be135af904264acd0e5128208e"
    sha256 cellar: :any,                 sonoma:         "d33786195b7cce4ce7b138033ea173a89a8c793e23eddb16192d4afa0bc1044a"
    sha256 cellar: :any,                 ventura:        "041edc2b9791fdcaf9913b0be48961f9722d58999511743eaaffb2164faf7dcf"
    sha256 cellar: :any,                 monterey:       "996a93823babcbdcf7c92f258ceec58a5f6408b3cf430bb4722e81e8e0f695bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ed804fc2087014c46793e71f3b7cb20dccc24d48c81607747a91ab772fd89f"
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