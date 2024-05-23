class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.51ortp-5.3.51.tar.bz2"
    sha256 "018f20adb755b73c307bbe147dad66c935e35e8e81023ecfd8b42964a1dec625"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.51bctoolbox-5.3.51.tar.bz2"
      sha256 "70681a123a7345160fcefd13b451d6f508e1e0c50ed579d681b93f1bcb8354b0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4bcdf22e157836e7bef08b8c262eda5545d0a84ed73789584ca9084f32f46f0"
    sha256 cellar: :any,                 arm64_ventura:  "ff50f415d2e314898f1614879222616080be3ae4ed18aab0dc3fca9b52232fa6"
    sha256 cellar: :any,                 arm64_monterey: "158297f12edbdc29d96d630b41b8f0c27ebad3ea92a69aa3b316db3c3bf7cac1"
    sha256 cellar: :any,                 sonoma:         "52be90e8fe4eca597c916992919d4140a70bb0e8faec2d0c86ab1c17bb2c877e"
    sha256 cellar: :any,                 ventura:        "71be1cd251702a8a2de0b19f57d082a67cf7995adac0501b5260862f039adba8"
    sha256 cellar: :any,                 monterey:       "478fa5a3682545cf6224428e3f77282d9f7c634e6162994e67a4ed7085a2d05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36418e06480a98a54f297f0175932e110eaae23a284bcb2f39b075c6f13c116c"
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