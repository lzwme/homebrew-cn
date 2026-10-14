class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.33/linphone-sdk-5.5.33.tar.bz2"
  sha256 "d492d736b76633e919b4e4a53744f4dd8b4be44cead374ca7a0de2e42e5ec507"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "262db7e8dd1c59de4c560154fb853655b133894b90cd9d60767567b3786ef0d0"
    sha256 cellar: :any, arm64_tahoe:       "6935b6386fcd7c8b5698747a8f2d7636ec95ab42d9f6e5e964cd6b58aeddb4ba"
    sha256 cellar: :any, arm64_sequoia:     "c4ee4c61fc9ab0a9aa793e0d6be8cb4a6758ded3cbe75bfa2be0c42dd1330510"
    sha256 cellar: :any, arm64_linux:       "9132e0f00ce5235e39992822bc223524e3b291ac246b4a36a1234603d5b58a1a"
    sha256 cellar: :any, x86_64_linux:      "d23f47fac56aa1116104c7c9a0ffe3d65eaca054fd8c77cfcf48b524622a721c"
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