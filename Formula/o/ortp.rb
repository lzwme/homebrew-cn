class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.36ortp-5.3.36.tar.bz2"
    sha256 "5655acf933d9b5d3bf6544e33cb2ebc6020b53624a205175677c1c7029aa079a"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.36bctoolbox-5.3.36.tar.bz2"
      sha256 "228c44db2a5231721b245b50e284b813171a1e758cbf7cbb27758be303c89cc6"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5138dd44532d6c2c49f1b455cc5090d26a8c7c70f2142e2270c33c92041eddf"
    sha256 cellar: :any,                 arm64_ventura:  "fe0486e05f6f57ed51a9bbe7a41c0aed18a2b4b8baea9b3440ffba24bfa61f4e"
    sha256 cellar: :any,                 arm64_monterey: "6eeecfd62e57e8da6f4b4b81149bf1568b68e74f46bfb8895c8b40dedec292cc"
    sha256 cellar: :any,                 sonoma:         "28576975c35e5b29586f37c49765d6258364031553fef897a765af465db3304e"
    sha256 cellar: :any,                 ventura:        "edb9270be64821a7bb3e81c27ad692828b6152818906c88232f49501cbbabff2"
    sha256 cellar: :any,                 monterey:       "d40799240c7cccd6ff445a02227aab089180b181c3a91d957bd4dde17943076c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d032cfd1f1de37f99e5a172e5cdee2686790dd4982e88892b9a69ef8814985"
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