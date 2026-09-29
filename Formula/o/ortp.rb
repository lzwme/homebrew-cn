class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.24/linphone-sdk-5.5.24.tar.bz2"
  sha256 "44922b7016e5bd00eb7b92405c4c090052114d4b402e60c586d19ddea5a0b2b0"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "08279ee6c0ab2114eceaa794341b5a20b7cbf67937cd1d35f83eba51caf35013"
    sha256 cellar: :any, arm64_tahoe:       "91d79aa508e851f0cf9b7c8cb7dee37b7ce0d16e256c175f28c9005c0ef13a98"
    sha256 cellar: :any, arm64_sequoia:     "9fc9343272801633d4eaf3b63787739b54a932f2b89fee31143815b7b3519b51"
    sha256 cellar: :any, arm64_linux:       "a675840d153c65697b21f5808abbbd9b9f1374dda58b7e18101d9f62ed2b1d98"
    sha256 cellar: :any, x86_64_linux:      "9ea61eb1cc90302a128951656f143af62f6d2442b4186f62025324fc70a9a6b2"
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