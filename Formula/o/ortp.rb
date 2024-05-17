class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.50ortp-5.3.50.tar.bz2"
    sha256 "4db9219cdd0bc4f3cbabe754b946fc9246cc7d03d59022b36592a2742544d5b7"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.50bctoolbox-5.3.50.tar.bz2"
      sha256 "e222dea33e2fb0d72f8462e14140e9c1f90c7d59746b799017f53a83ea5b356f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f399340ca444cdfdf5dca756054f40b10aef99a9419674721653551084d3b222"
    sha256 cellar: :any,                 arm64_ventura:  "be4aadddacb0705ca72867f747197546125e42f09af289477537b107b6379762"
    sha256 cellar: :any,                 arm64_monterey: "f02e2961fe2881abd64dcf6c8169fb5de328af1b7b55c43015a9e12ddbf4e71e"
    sha256 cellar: :any,                 sonoma:         "2e1346ed807e31c48c854a31f96caf50a9b06f961bca8dd512ba154bf3f7c680"
    sha256 cellar: :any,                 ventura:        "5b436aaa2c4989dc5ce7a45d8a1aa8ed69342f74722ade662f3e5182201587e8"
    sha256 cellar: :any,                 monterey:       "6758720d8de2802064878fb79a19938ca69986c8d64f67904504a5be9aa9882f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2de2bd0387713fa282059f18846664a3bb0b8d310794b7be3f964f48f6cdb6"
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