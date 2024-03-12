class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.34ortp-5.3.34.tar.bz2"
    sha256 "1c54ebec323f2ba8c10a7831c8e8146a41e1464c443a91d32950941ccbed3ec0"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.34bctoolbox-5.3.34.tar.bz2"
      sha256 "573b5ac585ec4f4e6ca888d773a309930e603b6d2da1ffc88a28bbfee05e4575"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e14af3519efcbc423f54948686a2c3cd6a8c07c29a3c62888995a811adb7cea6"
    sha256 cellar: :any,                 arm64_ventura:  "97504b727370bb7eb510c8950c200c1b819743ce1f080f27de2748e3c2e8a522"
    sha256 cellar: :any,                 arm64_monterey: "c545bf975213a31ca998893f87a3eca86b3c4267ff7eeb41c1ca7869a404f129"
    sha256 cellar: :any,                 sonoma:         "e3f8aca48a9b04183b1a3720bba579601f560607e13173861f0cb8671b082ecd"
    sha256 cellar: :any,                 ventura:        "c61d0ff945c3aa8449ba5a0b10ed7ddab257dd9dec88f27a2798d8f92426c5b9"
    sha256 cellar: :any,                 monterey:       "895ccdda8dadbe6f95928542e4774f51577c811ad6fb8e95a26ed67b75fd05e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8fcad08e17af0ad213afd6d3bd9cc2082e3986357fb5d8b7ef5fcaec6a97e4"
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