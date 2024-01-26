class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.13ortp-5.3.13.tar.bz2"
    sha256 "68a45a276ca020237e7b2cf1f77103ab9ec41aa7afa5c815212b29e37af4373a"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.13bctoolbox-5.3.13.tar.bz2"
      sha256 "d59e4b1c0c659d3afac0b04305b7171efe1acb0fb178a299832c9dc8f13a69fb"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1a3f298590904458f7fe42c04e88591be75a5c52f14841a8f1423d52a1247de3"
    sha256 cellar: :any,                 arm64_ventura:  "f881e7ede3a2ed99015c7dbb61bdbaa8344130affec566c8490739abb5cab1e8"
    sha256 cellar: :any,                 arm64_monterey: "3b8666ee8d031fe710a763aa81c592259cafa6dc82f640ee55779e249e64b41b"
    sha256 cellar: :any,                 sonoma:         "d21945769a269442ce34f994b69dc2423019e9b377dbe4615bdb372c80bfae3a"
    sha256 cellar: :any,                 ventura:        "d5b1301cc2cb33521b034f0a0708bdab3747e77387959469b170aa086e0fa69f"
    sha256 cellar: :any,                 monterey:       "2e786fd563797621b1b139c1810ef4dc157a59affc8ded7fd45830283f60f5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "459347de7ad3816bc529fb4671439b5a781c48b62bc31ac37c34cfbc73ed4936"
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