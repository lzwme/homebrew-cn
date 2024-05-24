class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.52ortp-5.3.52.tar.bz2"
    sha256 "cbe9b5f0ae04ae2a7585f9330ba89ce19a80c9d3df7717072f7127b5bff7b569"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.52bctoolbox-5.3.52.tar.bz2"
      sha256 "b5486f028fb0585682f37422ff7f7f1a797e1dc4479d54d855d088576fd36210"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dae0b931d696cc6fd20e15b3b0e7df443efff000aa31dbaf0c662725abb69794"
    sha256 cellar: :any,                 arm64_ventura:  "3537456ad90b64991bf44ea1a414451167ce0ea013efee74fca85c7ed76fe191"
    sha256 cellar: :any,                 arm64_monterey: "ceba6496729690e5c38b769d00e5bcfc9b3ab5711702467666da55637c5a42fe"
    sha256 cellar: :any,                 sonoma:         "eee1c2545b7063d9108c8ba535c1acedb40a2eb20f2f92bc33b9f4f20efa0b94"
    sha256 cellar: :any,                 ventura:        "fee641c0b577686505c705cf3180658004466326f644eb3ca28b3f936cd34957"
    sha256 cellar: :any,                 monterey:       "fa866ca310ae16486073b6a2c4c1ef3d252dfbdd713d172b21d9cfadc07ae23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132f81e97b27cf277af1a5dda4a0b406af9704b95bd9d6e39de217dc1436212a"
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