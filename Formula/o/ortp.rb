class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.2/linphone-sdk-5.5.2.tar.bz2"
  sha256 "2a279bf577861b28f6d6890b16166d18de08c9307935acfa9d293d20dc1e1e36"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8af75984d2ad911d3dea84447e8b415869dbe784d7e7f90aab9278868f036145"
    sha256 cellar: :any, arm64_sequoia: "5f152f6bf3de503327377f79dc7515b889d03e3f9d3251d5cfa1910d61a6fa3f"
    sha256 cellar: :any, arm64_sonoma:  "f4b11b278d237c92148802e30fb3ca201da79ec3f53d050a21723945549ae078"
    sha256 cellar: :any, sonoma:        "fcedebc3b6a666b60a473b0b1f172b9935ff783c685b37c223f39189bb9ea6e1"
    sha256 cellar: :any, arm64_linux:   "ef0ae317f8baff3fdf51b18734eaaca91cb31abae534c602122762fb1d0cd3dd"
    sha256 cellar: :any, x86_64_linux:  "cc0ae0a80d615eb374cebeff005bb8a3b6e9f4b748ee1a8cb13f9f8c4eef16ad"
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