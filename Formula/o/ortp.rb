class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.22/linphone-sdk-5.5.22.tar.bz2"
  sha256 "328488a97293567e6a37e3863febc1d95aa00be61a42172fe408d422aa1adf7a"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b15c0ae3aaf56e77f971814df8604a189826d858184b322a07ece64b4432591f"
    sha256 cellar: :any, arm64_tahoe:       "456ef4427c53ef7da6dbdb9072deb4c8b628a8d9c759f7122f6c8bca9a8569b4"
    sha256 cellar: :any, arm64_sequoia:     "4e402be13e9ff361565270e154385df92103c5a89d9d3302c842e69232c85673"
    sha256 cellar: :any, arm64_linux:       "c9a1d73c93b7a938392ec98e65778e0b35e6c1a1631cfef6dc576b452cf0fe6c"
    sha256 cellar: :any, x86_64_linux:      "a8c0348df645c1f6bea73c75e370415c369353db428e5dc8ad14a1f02a5a015a"
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