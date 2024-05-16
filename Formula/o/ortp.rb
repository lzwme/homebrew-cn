class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.49ortp-5.3.49.tar.bz2"
    sha256 "fd04fc26d2ff3f7a2a10ca976968d93ba9142bd7902cdfff68377ddb74c53bae"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.49bctoolbox-5.3.49.tar.bz2"
      sha256 "1b8a878d7ba780d3f3901570d740ef860fd655e28a8ea51a66711e47d693cb00"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aad2c2d2294c9267bf4c95e0593512e3ec1dbff0021c8ae7858d9adeb52dc2e8"
    sha256 cellar: :any,                 arm64_ventura:  "80500d6158f46851fd9f1c9516ba88a6a810d22163aa2fe47267326ca710587c"
    sha256 cellar: :any,                 arm64_monterey: "ce8002d188e65552dff67499f3ebf95fdbf3a7cfbc8cd2d8441720c58d0948d2"
    sha256 cellar: :any,                 sonoma:         "94eddd9989c894b4a0f0a9bf99b8bfdd706c03f3052d0b667fc5616e5a1c0dd8"
    sha256 cellar: :any,                 ventura:        "f43694e63d0e23ae5c3eeff006235d7eec6b5f144731871bddc53a4d0c6b53ea"
    sha256 cellar: :any,                 monterey:       "563ec2c724e8c137ba708cb48a9b99d8cc62a6fa47addecbcda7f99d89256271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945f840df0180d9665dd814e511c74e750983a5466343765f1c7adce0308cffa"
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