class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.65ortp-5.3.65.tar.bz2"
    sha256 "eb2744604493701a477d596680696f935135a3efc0f103b258b100098c7b12b5"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.65bctoolbox-5.3.65.tar.bz2"
      sha256 "62d3e2e610949be0d00269070d1d164f0d4117051ac75b00422d6569fca91ae0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5a7f0e904c12dfd2a6e8ca5f59979ddd6790a8873424410a53d28a3191db00b"
    sha256 cellar: :any,                 arm64_ventura:  "bde1e65ef8d5f2396a1979e8eee44eaf5f743e5c0ad4f16be5366a0b321319fe"
    sha256 cellar: :any,                 arm64_monterey: "b77fa43ce0c20a59df546df6fd12c3422d3e83265c548049788ba47314155fae"
    sha256 cellar: :any,                 sonoma:         "88aa048f00e28f907d1c15639e12d939e66ab128e18d77babf41486b61a68df1"
    sha256 cellar: :any,                 ventura:        "2ea68fb72ab25717860a0e921503e4aca47e9b7790abc37043c096c7ce719e18"
    sha256 cellar: :any,                 monterey:       "1525c79bca8c6f7cadabfbea2db085653c7a24d6af406125a8098d051da4c655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941735b2340d70cffb97c4a4fd6cd361c9f838d95a1aa45b5932a034511615cd"
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