class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.15/linphone-sdk-5.5.15.tar.bz2"
  sha256 "8465ede5516baa0ee70d41f232f762543194a8a88608f1149b4678564276cf55"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "28898957d148b8ea3d2e6640ff8ddb69df2a9ad336dc8e4330dca7899302a04e"
    sha256 cellar: :any, arm64_sequoia: "b39838a219922b670552d3d14d7d85c31467ec5a41c962015e14ec5958e5326b"
    sha256 cellar: :any, arm64_sonoma:  "128dcbd09a3152cc74ff5bf085c5d7d213574f1d152b9f80addfead19987e274"
    sha256 cellar: :any, sonoma:        "f5a0d9d9ba3b4efce7d0ea5f4af405d6c9c2c0d4a746123047ccf1ae34181dec"
    sha256 cellar: :any, arm64_linux:   "1fa3628d0e23c8128ebd9071d91e3b2b48f176ae4ba80f36a91c5a21d91d16c8"
    sha256 cellar: :any, x86_64_linux:  "429129da4b11b224c775d11f52d92dd530d9bbc28b9363758e735184f2561ba4"
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