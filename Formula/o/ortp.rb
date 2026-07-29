class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.13/linphone-sdk-5.5.13.tar.bz2"
  sha256 "6c205380c206a79e48c4d2d12a7d575e96cd376cd20d4420c1df9e64250dc507"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c7d8bbc68d4d15ebf39baf298e853053a72fc33baa459366a602d806a9bd7d11"
    sha256 cellar: :any, arm64_sequoia: "8761b4ad2136dd200b9497efde748eb5b83cd3c42f35288b3672e905c3eb0d52"
    sha256 cellar: :any, arm64_sonoma:  "eb7fc1ac2c023f4193e65659b608ba5a2e81eee4dc5831951f26a444a5876638"
    sha256 cellar: :any, sonoma:        "0ff53d4b1a61e6d950d5f2e438858a4d2621e130c3ca283b4d4e0927c5e28dd6"
    sha256 cellar: :any, arm64_linux:   "b4299ca7c60281ac97e36e987c3c3281e94aa1f29bc662c9fb763c2a4912076d"
    sha256 cellar: :any, x86_64_linux:  "246b286a76c4a66c81c30b2c046f2b7ca9a5b2296c79f1161e728d7bfab9a40c"
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