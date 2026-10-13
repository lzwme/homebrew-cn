class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.32/linphone-sdk-5.5.32.tar.bz2"
  sha256 "56fb48e909f4f8d00987887328fd2291e686ab776676bf38b0a93580a505c9bb"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d37b42341648bf5f5280e734ff790c6a8d0b86690fb348f0a8eddddb89c92533"
    sha256 cellar: :any, arm64_tahoe:       "ee10653826ebd3602eca2575eb76d4175bc0fe7b81a5ef3688ab9ed3e4fddd50"
    sha256 cellar: :any, arm64_sequoia:     "6e08856ba5d5222a0ca0e6d905f574438be5d74ff0cc0d12fa159544c3131377"
    sha256 cellar: :any, arm64_linux:       "3501c50e27ca6a2e46589357012cef3c46baabcd0b51af7299913761a2a80545"
    sha256 cellar: :any, x86_64_linux:      "1d5bdbab5a532c143951ea78d37221e0e82b570e1f1b0cf5d934821569f75224"
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