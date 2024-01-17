class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.10ortp-5.3.10.tar.bz2"
    sha256 "8e17a1f56da6b75e34e47c7de3f813d2f824caef6d167513c7354590123ea77a"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.10bctoolbox-5.3.10.tar.bz2"
      sha256 "7f07c01bf9c7760db2ca06ef71487f79ced8fd9c7aeaf5310c3275e5dc5af64a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a812ab958da1f3ebe02d36ae59ffa32c1a55071352cf7a87297ece10fd90b3c0"
    sha256 cellar: :any,                 arm64_ventura:  "8143a92408b23a71bd44eb2da12e6d923c89c95ad513f1b6c529416bd21401f1"
    sha256 cellar: :any,                 arm64_monterey: "439fad7d4bb58a61717e5ffead594f390c6a5801651cc7fbc3f5f805f9017724"
    sha256 cellar: :any,                 sonoma:         "18b4e2a7fe3634d2fc5443f12ae9b548f8151a152d779548e9d3eb292fbcf48b"
    sha256 cellar: :any,                 ventura:        "68b0db1ab6ad0fc6a349028b6e0d629e14912b591ee257203578ca7308c56cb6"
    sha256 cellar: :any,                 monterey:       "abcba46ca4df61d1d74957adf734ff01764d3be5bab02ef5fc047f135753764b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b77c11200c61cd527b5926c871d12293830e06494471bdcd0ae67248d49428"
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