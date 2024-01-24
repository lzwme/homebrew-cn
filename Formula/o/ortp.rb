class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.12ortp-5.3.12.tar.bz2"
    sha256 "704bf07a811e52e1c063cc0eb8709d84bf0c3bcd942b0c1175f01257c0fff6be"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.12bctoolbox-5.3.12.tar.bz2"
      sha256 "ab95ac71ef1bd08a4b8dbc75f9b74c341eb3da2b0c7f6a5949e3489b09999d2a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd7ee6fe6d1a9af0802b0d9c8f73ef1e9e0d609aef0087de902bf40011c357b8"
    sha256 cellar: :any,                 arm64_ventura:  "268d971993bb113e4c9bafd2c4b4d3bf80f5f4ab0a1b492be1e9c1c80c19578e"
    sha256 cellar: :any,                 arm64_monterey: "c36ece8a6431df15252a2ad45b9758b3d25de0e9601514241c88e027c51dab1e"
    sha256 cellar: :any,                 sonoma:         "3933895f2234935c59703e725334baa8f3fe23de9351f163d825f4714c2b8b6d"
    sha256 cellar: :any,                 ventura:        "a1ab393396f7778e661eb6cba6abaf115f19e9e77c9e4f71e811be01b9e1bc91"
    sha256 cellar: :any,                 monterey:       "3c9d9dcfb8588a05592161100f1aa36d13f1a790c63e2162cde78c85227affe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f90ff01343516f0f50bb1c48dd1025314e609e252b07edc65c75c0130cfc133"
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