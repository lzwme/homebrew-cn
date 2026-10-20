class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.34/linphone-sdk-5.5.34.tar.bz2"
  sha256 "be588124229ba185baa87029a06258a2b1f903b1ed291264dd476697d1225507"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c0098acba777f92b75bd39af4b63d0f2cf56eb338dc9dd07eb93e9d2fa9938a"
    sha256 cellar: :any, arm64_tahoe:       "bee179589d344ef913fe5578d18e094f2502f1b7ef9b8c7818ca0c35378fe708"
    sha256 cellar: :any, arm64_sequoia:     "a77563ad4a32d91eaa2065e77924f1d2a3dd1bab3fa23e28ae8f0a2e467ef7d7"
    sha256 cellar: :any, arm64_linux:       "e93a6f24197d80a9313335dabeff1615710a3ff6d1f4e6b9a0cf121894ce9475"
    sha256 cellar: :any, x86_64_linux:      "9ead8645dee9c51dc62abc9155aa3f5971e58495052331dce145f4812f1fa91e"
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