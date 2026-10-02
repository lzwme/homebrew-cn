class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.29/linphone-sdk-5.5.29.tar.bz2"
  sha256 "06acf808bf99fe15fa3c0df61e3db7680ec86e041bd1dabbbcf7a88f4c0ee23b"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f6da6bb18e11e464f5dfc364c6bf8b3bcc33cfd66e610384756c88e7a361e3f9"
    sha256 cellar: :any, arm64_tahoe:       "a70b5357f1caeb4b9d95ca1a01d9dac0f160c75a6bc0b75d2192118981cd161c"
    sha256 cellar: :any, arm64_sequoia:     "59b19c92dbd8e301754198ae55a5aa9aadca033f5ea41a65479bd145cac96d8f"
    sha256 cellar: :any, arm64_linux:       "592924d3796573000726bcbdc8172466a78146c067a1a6b8eb90d4191a17a1ce"
    sha256 cellar: :any, x86_64_linux:      "59af85feb7e12f917f587e67a144c4cadf8f49485cc9e8190e7808dfb3e7ee8c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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