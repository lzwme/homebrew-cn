class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.25ortp-5.3.25.tar.bz2"
    sha256 "f6c792df7f6fe0eab1e98613a0416d5c706ddda7737c1ecabb30225d59f533fe"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.25bctoolbox-5.3.25.tar.bz2"
      sha256 "1472ba96b93d5935bfcce6e58ae9baa90db43dd7c95e3c6aae5edaf52fee1e98"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c265d6a69e77fc9edabd8d53fd656ed20dc25a531fde49fec1dbdc145633f430"
    sha256 cellar: :any,                 arm64_ventura:  "562480a64bb4c40848edaf213c95d7ed04e956dab769b7e59384c49bfc89b062"
    sha256 cellar: :any,                 arm64_monterey: "9ffef2ca3deff1e0fd3938130ccf67e728ce9a22dd344e30aa4bf97e5a1aa77f"
    sha256 cellar: :any,                 sonoma:         "a34a7d367a512c9f203d096a2ff8e852a632e422f329a10aa9664725e19168e9"
    sha256 cellar: :any,                 ventura:        "2de4b6144d4aca3458c7c65b2c38c80b296ed00de97946580d2aa5ce201eb224"
    sha256 cellar: :any,                 monterey:       "71744b6b282d0a5dca95aaa4f2235cdeb6eb13277e200a9f27231015b03ad784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a573284ed98f70afafadbc97efad8f13dd5eac6d6e52f0991538db289c41639"
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