class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.28/linphone-sdk-5.5.28.tar.bz2"
  sha256 "4a35fced95ca740b8c8061312c672bda4c0e918d7b7572c8a0a599c6fc0ca995"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e33553c7a89b974624829535c1024d7cb441513f1079e0664cac67b21d2ed9d7"
    sha256 cellar: :any, arm64_tahoe:       "27badc8c5c8adc4e07640cbaef0f0f8a0aa1b6c3ccb0780445cb0ee09c42d968"
    sha256 cellar: :any, arm64_sequoia:     "12fc039bf971041e8125c9a30d54d794c88e34452cdceac6220ecbfd52f901ac"
    sha256 cellar: :any, arm64_linux:       "1de4bdda6c69b7364c0e485d310db056bfb1956e37e3da2717637444bafdba9e"
    sha256 cellar: :any, x86_64_linux:      "e451c412e5222f557c28055b655841315fdcdd9e5d04ae741271f0bd669e23a3"
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