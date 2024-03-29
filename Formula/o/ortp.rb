class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.37ortp-5.3.37.tar.bz2"
    sha256 "bfacab68b1fd9d2439acfa8578a5406369ae0f6a70969fcbce829ecde760391f"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.37bctoolbox-5.3.37.tar.bz2"
      sha256 "55da6932e61ec12f6f312e3e3dce611a94d27e36e14a30bf92586e2be3009464"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db6e4d66f4219d9f2807ad837ded6c5790af69779933815aec4ac75cc1f1793b"
    sha256 cellar: :any,                 arm64_ventura:  "ea59493da780263182559c7b77808ca938c8e039251d7d0f88692e61866b84e3"
    sha256 cellar: :any,                 arm64_monterey: "cca66e6d7481668fc66ac63ce9b46fec6360c20e9bc2a9efb5ef3368828cb9eb"
    sha256 cellar: :any,                 sonoma:         "d7a46f90f47b9e479fa4a936f36fb3acb5f5f701710e5e685e3a3ad7c6b384ea"
    sha256 cellar: :any,                 ventura:        "688700cc8b4a575cc7437305cd78ba783d6548282672fe86576b664061821664"
    sha256 cellar: :any,                 monterey:       "06b917d4430b47775f85572e39606da267d0588a1d3b2eefd40a35c733f19fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81b6c241ba758796487a96cabde3d09ce8876b427124c8e0900d42e7732116e7"
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