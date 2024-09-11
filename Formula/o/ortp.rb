class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.81ortp-5.3.81.tar.bz2"
    sha256 "bed08b4edf91ee7c446fe0bf17e3144f134aa38a769191280308a19292e0f844"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.81bctoolbox-5.3.81.tar.bz2"
      sha256 "06773d32fab7d35461f77a7d1ad5d2ee523a254fc5873687be78c203afa2c2e9"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4f7e1e0d2dcb59bd549e3729920f94029ee3533e50f1a99f78c2aa0e7e767304"
    sha256 cellar: :any,                 arm64_sonoma:   "62487db62cd78fa0be52249a143240fe05434b122ce781c39b204eef4cd77573"
    sha256 cellar: :any,                 arm64_ventura:  "a2fecff0f22e4f9449a317c3c0bcd74e64b3228ca51093f92db4582dc191d894"
    sha256 cellar: :any,                 arm64_monterey: "6b022c417495707da6805d978553a187e36d6c2b77b70101fd055141a8f92c4e"
    sha256 cellar: :any,                 sonoma:         "0043c0f52129aa7f6d033a0f98269388a24519b9afc8b53b522cb0480aac4526"
    sha256 cellar: :any,                 ventura:        "bc89374740df6641af96408ca8e30d37bb4e1e760db5224748810e9a8adf5f01"
    sha256 cellar: :any,                 monterey:       "32289f44e6c1b47dbbf27b2ef07a55b13e136b44d38cb573adfb28654bcf17ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b183438d868e022a30ab86a0a43eb70828c9b3aae5a1a19735434b1ce0076b6"
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