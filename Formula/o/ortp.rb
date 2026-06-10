class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.1/linphone-sdk-5.5.1.tar.bz2"
  sha256 "518a0481f3064b2063c0dcfc94b2d50743d6aa84175a628554eff4ae58162ec0"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4189e39b140e171251bacd0becc85719af4e9ebb9dc6a240aed9c46307a2e4f5"
    sha256 cellar: :any, arm64_sequoia: "307095f1023854055d00cbe114596d783616190377a1c0cf1f15f80e87ed7749"
    sha256 cellar: :any, arm64_sonoma:  "a21a16a4d6897fb527d77fd285350581f5ab05094b8b80bff431ee5ddf20a01f"
    sha256 cellar: :any, sonoma:        "51f2ff77ee150291fd40d89c9204846bd98f1d92907869dca24d49d2f636855f"
    sha256 cellar: :any, arm64_linux:   "7a312617b6133b36001a335f9a8584b27e6c5bcbb973f085637d7c57aeaed0fb"
    sha256 cellar: :any, x86_64_linux:  "817cdf64d253e7553dd6a30df90a8eb39bd6d7af08cc329034c3b23b3f34cb91"
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