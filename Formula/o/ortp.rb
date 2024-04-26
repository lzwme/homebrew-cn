class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.45ortp-5.3.45.tar.bz2"
    sha256 "4fcd52b9cc924fccf2ee689ea89f0aff5f6b9a13eac8ae392aad7e058d436215"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.45bctoolbox-5.3.45.tar.bz2"
      sha256 "265181581cd3de7fcedcb7ac69194903c0ead013f07c4d001779aec7ce3fceb1"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5683b0fce67e020a93db8a0cc6d66a005fdfd74d7b4d7f28e03af21ae54e54e2"
    sha256 cellar: :any,                 arm64_ventura:  "ec713afc7d307215e784fb536d0f37184e2c2e1a8ff8ab6517c906c6f8e8657c"
    sha256 cellar: :any,                 arm64_monterey: "69e4b4ea776bcce76a7d89816e8ddead2cd20286b48b758d13102a33823298d7"
    sha256 cellar: :any,                 sonoma:         "3e3719099e40583dd5095b1a539fb27ab4624f51910bd15eb793d7fafc883bb6"
    sha256 cellar: :any,                 ventura:        "992d2667ea63be34a2c745d3e853f649ac84bcceeda42c95797403cb1cab1a7e"
    sha256 cellar: :any,                 monterey:       "ce8d675ee5a87ac735d72a5cad213f81710c114b31ac90bbbf429e1fbc319efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95544c8eca17ac62d9ee51d66bb9d527a999f9efce5ea0037ae54946abcf0114"
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