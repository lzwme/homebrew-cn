class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.79ortp-5.3.79.tar.bz2"
    sha256 "73334bef5fd6d6c9d6c74f6e45c0cb7d895eeb5f703be710a48dc12ebd4b93cc"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.79bctoolbox-5.3.79.tar.bz2"
      sha256 "4d1e0e10d91c7221cc9170429081ce5ebadc2c37aadaea1ecc9a4a9f574e8159"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ca892914239b1f1eb5f2c7d14b10e09547f69f2fb793d701dce5282326ea00d"
    sha256 cellar: :any,                 arm64_ventura:  "c19d2ffa4ebd74de51278f02cb0fdc0cd660fb56721395388ab78970347a476c"
    sha256 cellar: :any,                 arm64_monterey: "8a5505f8525ff4c036c86ec3639fd603d77601e81ac0eb3c68db79ab280ef3e6"
    sha256 cellar: :any,                 sonoma:         "ce277108bfe59752070e24b75045782eb6fc9fa9238cf5bb5f5d9757970be629"
    sha256 cellar: :any,                 ventura:        "9a79db30c98de473f07e7dd367781a3c93ff40a37bc23a11ec817957d11c3fc6"
    sha256 cellar: :any,                 monterey:       "e1ec1945d87f3e4c2f660501eced9d779febf6c168a86908ec0d9d32c3ddc0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f07a92a8034fa84efb6a4d245b5d9df6557bbf002a9c99562f480335b0ff10"
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