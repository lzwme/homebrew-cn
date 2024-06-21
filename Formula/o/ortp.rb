class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.60ortp-5.3.60.tar.bz2"
    sha256 "09cfb630a329b70d3eec66d8dc504560586ff64b9bacb2bf2ce9bb784317f65e"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.60bctoolbox-5.3.60.tar.bz2"
      sha256 "70e11d214728faf7fa5a329dc9d692aee3eb7a0721d9643e10b18dc093e9efd0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0636529e1d6304cf38ddd1cd3de45bda6e53d5fd3d4d827711cbf7a8ad328637"
    sha256 cellar: :any,                 arm64_ventura:  "a28f324abbf041bbd6aa7390172c273da9f7bb59e5c452145f427aad5a2fbc98"
    sha256 cellar: :any,                 arm64_monterey: "30bde8a0d866c40678e41d7d2b392f893cf6bc86932dbb7e998d6f29aa9c6087"
    sha256 cellar: :any,                 sonoma:         "5ec1c2d946bc7a0566c71af8ade090acfd9c23a7c7e0ed1fc9441c9b4553132a"
    sha256 cellar: :any,                 ventura:        "66605eda32d41e0e73bd9aad02fa18438cb0f1a06db160259eaebd21bca84bfa"
    sha256 cellar: :any,                 monterey:       "2bdb576a355e9df337e4ca21b4d354f181d010c8938875aa542481637dc52366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3835747af0530c245cbb95536db3557478d8c358f80127136f19a21e28ece33"
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