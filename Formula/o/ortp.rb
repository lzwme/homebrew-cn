class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.6/linphone-sdk-5.5.6.tar.bz2"
  sha256 "abde36ececa65bcd9b0241d6baadf7ad185732b3e3ecbd5ccbaffa315e82b926"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57c7ac102da5bacc37eacb4950929328218567be103360678fffbdd51652d6b4"
    sha256 cellar: :any, arm64_sequoia: "ca383ebceff27c5fa502642e6cb6dc5b8eaf653863e7c3b008aef7780b7aa5d3"
    sha256 cellar: :any, arm64_sonoma:  "ca71845b9f6ac9dd1a836b6b28600dd4be7a5c7a9e71e7814a3dcbf70a937652"
    sha256 cellar: :any, sonoma:        "bd2bcd1b365aaed70e63b03a38b32f22b65d59ba45ee651bfeae80ebf2cc99c6"
    sha256 cellar: :any, arm64_linux:   "ccea44433cd8b2222368b5aaf8dc4c9fc34ae0909932f2068c706618bb51b5e9"
    sha256 cellar: :any, x86_64_linux:  "2c47b6dcee47da410f81fcea7f8887c26df941725249663aab29e77981160057"
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