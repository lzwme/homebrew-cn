class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.27/linphone-sdk-5.5.27.tar.bz2"
  sha256 "c9e25ce7b788d9863fdba80a8cb151c996be0d95befabc0cd29cb73aeb3b4ca1"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "002baf0e5adbf6370dbf4d8addc0e3ea0f9ed838343fb0e6575dbee9832bc154"
    sha256 cellar: :any, arm64_tahoe:       "d41107b88e02acb8bdc5e7c6fb0062406b3f15d4b8721930b2d8bdd6808eea53"
    sha256 cellar: :any, arm64_sequoia:     "b7a3a18b4fe1fc611fbb9720461f7615270b562add752940d2b7ad862d856ea2"
    sha256 cellar: :any, arm64_linux:       "487898fd7d184d431caa7af41d8cd93454d668d24c4446654aaf2ef8f1c5eac9"
    sha256 cellar: :any, x86_64_linux:      "a2c8387d00cee886fcdd063e6075a19804cc89f8b4761566218a398b265f34ec"
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