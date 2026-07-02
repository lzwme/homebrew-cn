class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.10/linphone-sdk-5.5.10.tar.bz2"
  sha256 "09c113650c58d721647253f01ac80ba86fe28b76d7925aebf199348f6aeb1ff5"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "995c75b8113eb7823cba43a3e2e78a7294bb88a62a67233b0779ba39cdb5f10e"
    sha256 cellar: :any, arm64_sequoia: "b53b8e7f0d4cf3137720ee7b413480dcce381df8532861ba3c3cad12948e1ff0"
    sha256 cellar: :any, arm64_sonoma:  "05a751ad19ad676c96aeabae874ebf4e25856d7ff0ead4e39a5874dfc995af2f"
    sha256 cellar: :any, sonoma:        "c8a87ccd4ecf2aa1276caac4074110a6b72132c46127ebbeeafaf07fbebf2bd9"
    sha256 cellar: :any, arm64_linux:   "32653bd3b7beb3745aa979d53d31affebe3e647f46770086455044c3e0b5627d"
    sha256 cellar: :any, x86_64_linux:  "e7d65e018b524b93e614a0909c0291b109152744e9e6740aa525ba464e26760b"
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