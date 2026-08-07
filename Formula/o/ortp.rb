class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.14/linphone-sdk-5.5.14.tar.bz2"
  sha256 "a26903aed4655467a9178afdbfac0d6078248d4494756837ef5268436c174cae"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a17a0af22a55005e4bfd1ac60f190e94536162126f927632e150723306bc5d11"
    sha256 cellar: :any, arm64_sequoia: "39b4f022ef85d5c7da8756a5d0374af07f1dbb3253518f25bde856c306b58ef9"
    sha256 cellar: :any, arm64_sonoma:  "9b6840097465cb41fda1817110c98888e49daa06a26e85c5c78dfbbc61748d01"
    sha256 cellar: :any, sonoma:        "6fbc320869fbcdd06df7c30020eb655d2232fe72bf7c973949ba9fdbcd410f79"
    sha256 cellar: :any, arm64_linux:   "27363142aef828f3881bdead4431b4c8daaf0089e43bf1109022d38eeeda16de"
    sha256 cellar: :any, x86_64_linux:  "da1a4370bd82499e36f47024b4152b4182eb6f810dc7a9ee98d1893f2bd03874"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3" # OpenSSL 4 is not supported in monorepo

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", "ortp", "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end