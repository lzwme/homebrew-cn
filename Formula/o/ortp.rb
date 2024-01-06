class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.7ortp-5.3.7.tar.bz2"
    sha256 "8cc6eb91f81c5283decfee0b6be6540cda388ceebdd82d7ff5a37e9f50540c32"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.7bctoolbox-5.3.7.tar.bz2"
      sha256 "ccbfa95bde6bd598939d5ab26468613ca9ea4a18aa9b785fd68021e54b5c7334"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41729a7dec0bd6effdc89ccb14164ecd9a51af4b2dc6691f25e6f6eb96def42e"
    sha256 cellar: :any,                 arm64_ventura:  "adf23222e2e59837c7be1bba82032b3464d28909e0319bc9ba71993a07c357c7"
    sha256 cellar: :any,                 arm64_monterey: "9b5afd754738f6d88de0b1a37856cf4b07d3bf024104fd2c3def600d569bc5e8"
    sha256 cellar: :any,                 sonoma:         "2e7457dd6d7beb964c209056b56da9301edd0a96d1e3e7748d5c2b64d88c1ca8"
    sha256 cellar: :any,                 ventura:        "f40b9581ba9263bad976eb1d1d259f666f1fc2eb5bc024491c1a3f8d1857278e"
    sha256 cellar: :any,                 monterey:       "687829191a78d7f33f3ac3d96d9eb7ace91b8b1014dd1dd3d40073b3b18d20e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4398ed5884a84a8edc24d24d94564fba1622d4d0bc4fa8d947dab9d89b954fb4"
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

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end