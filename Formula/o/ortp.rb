class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.9/linphone-sdk-5.5.9.tar.bz2"
  sha256 "f27ea0e310d08fdab8ac2786f026bb4ba5e05b3a9f9189d8a49b12393405c6f7"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2630d494e5ee0054541f6b0c06bb9964f57b35f6883bff68c5e44f20d5eb6461"
    sha256 cellar: :any, arm64_sequoia: "8668c973dddcc99dc724c117456f911e66ee81ae376be7df2ffb26d99ef0a720"
    sha256 cellar: :any, arm64_sonoma:  "f13a05cf1b4421dcc315c80b424f6d0449146eb115f0ac375e13c345a785d684"
    sha256 cellar: :any, sonoma:        "450692ad5f23f9e8e158939ca2da877e8960b15ed57ddc341fdd28fee470dc61"
    sha256 cellar: :any, arm64_linux:   "04c34be06abea5c7110207e4b72bda8732c9b57d4be216f3a337eeec75e38702"
    sha256 cellar: :any, x86_64_linux:  "7c176fe87d76755026beef82cc536797fc0964a1b6cd0da38ad9acab40ab491a"
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