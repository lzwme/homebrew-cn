class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.56ortp-5.3.56.tar.bz2"
    sha256 "cf7307878fac2acd5baff59d855f68106d07e7c4ab540d047372448397e5ecf2"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.56bctoolbox-5.3.56.tar.bz2"
      sha256 "9405a7c47bcac8a116e8acd033f9cf05e6ece1f3f6516aa1779096cb128a4437"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b6ca214e10a3385823c40fedb34b4ddf2d99ff69f0ef11d3d994ed567fa6148"
    sha256 cellar: :any,                 arm64_ventura:  "2be0ca5e36ffe825b9227c3c955dd63b96c342146d5ed37f4bdee3a9a9fb2dc5"
    sha256 cellar: :any,                 arm64_monterey: "c7e6f34c2fc151c7aaceebc2d8ee56329444089fa225bc7072829041173932ee"
    sha256 cellar: :any,                 sonoma:         "df490193795d73926d3c65e2ccdcca24288b764485c5e69c70d378cdb3b9930a"
    sha256 cellar: :any,                 ventura:        "5f2b56a658abefa3a07c7bd18394bfc7a0c521aeff5e96db2678450167bcd792"
    sha256 cellar: :any,                 monterey:       "de573581aacabfb692a567ce2727b0c47958904951a5f1ffaf82076931badd3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d77f5ace7e2fe58ba7ea6def10c21f1c8fd7b2ac982133b6c7bd20af8e5e620a"
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