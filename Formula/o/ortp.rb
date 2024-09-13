class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.83ortp-5.3.83.tar.bz2"
    sha256 "4080eefbf107b7a6afb087e4296d69af5ec407ee29280a7c63be6359be7bdac1"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.83bctoolbox-5.3.83.tar.bz2"
      sha256 "994c13740f9a9e95d6674514d9fbe552089babcfa115b78fc6adc0252383b2a7"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d6ad4641a38d82ae6855fdd346ca82226fc2b13c756aa9521031bf3442d2a21d"
    sha256 cellar: :any,                 arm64_sonoma:   "f234f678ce1ebbcf70d0e665870ad675734671f57b4a3cb7b388b81048d1dc38"
    sha256 cellar: :any,                 arm64_ventura:  "be3ccecf05e40915ed80062ca75b196aa8376238eaa1cb4078fe5fa04c9df7bd"
    sha256 cellar: :any,                 arm64_monterey: "80beb5c69ff190cf4dfe3347a51b3ffad7e7de4201b23ff3ffa79d06e08b4de6"
    sha256 cellar: :any,                 sonoma:         "0ade976ce75bd37282296b1f62516d9456f1d752e2353c26d01b42718deec40b"
    sha256 cellar: :any,                 ventura:        "4fca13c869e078f50200c226b2e633d47b97bdfd31735ba9c204f82592a8aa53"
    sha256 cellar: :any,                 monterey:       "256b56c1c65d5aa3fa1776b03ebe95ce1ef6f184d3a7626539fb30c102b7ad15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96513da356020d903314242021d34f57508809c8580b8a22c35e6f50ef1f5d50"
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