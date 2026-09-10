class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.20/linphone-sdk-5.5.20.tar.bz2"
  sha256 "9a90e856e1a191c687c241a17a128f490c71f87e8cf955b9de6e07fb8f18fcc2"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "482afa9a851b91c4acfa2d1234de71f817b3cf218aaeae2dbcc4ed697f4d0055"
    sha256 cellar: :any, arm64_sequoia: "b607754e44a089935cc4fcc7302bbfa95d9aed19d450db33842ce6b5f3672cfc"
    sha256 cellar: :any, arm64_sonoma:  "ad51f2380baee19cf67d7a826424b714cc4e0a8cc1140ccb3ffd33697827d81d"
    sha256 cellar: :any, arm64_linux:   "7e4dec71530c941ecea252580898e9d334e13bf8602cea3ad8be3acb19f14ad6"
    sha256 cellar: :any, x86_64_linux:  "bad70554a1c4dafd80d93602d290fe7e16eb9e77e3ed7fea4cd48d0ce96084c4"
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