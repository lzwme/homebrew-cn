class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.3/linphone-sdk-5.5.3.tar.bz2"
  sha256 "218c9ec09c887e28e7ce1a0e250704484c84ac631a031cab05ff350778faeb82"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25e98267092e0fe89a2ded9ad3e545e6742e33b3fd35010e2c3c5a4e51ef1ee5"
    sha256 cellar: :any, arm64_sequoia: "edd667bf262ca78815520b95a4245375ad726a32acf5a74ea1fa4bd6f101ef67"
    sha256 cellar: :any, arm64_sonoma:  "99876ebf2511db1c0ef0fcd2372c766fb9872d8f757b14f4df47ea7308a9bb61"
    sha256 cellar: :any, sonoma:        "dde5002f3b2b6fcd133af99aa4229af1f9c253618d9149ad578396d11e8672a4"
    sha256 cellar: :any, arm64_linux:   "7ad54f98296d5867932abac49e328e1d940b98459dfd425dab9ead9b1c1280eb"
    sha256 cellar: :any, x86_64_linux:  "855f72db5191a2a1c80fd24cf6e1c1d6e80e247a30e7982815d7dd667aebded7"
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