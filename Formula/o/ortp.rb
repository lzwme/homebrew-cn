class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.31/linphone-sdk-5.5.31.tar.bz2"
  sha256 "9cbdd450db3df610802e52daa671e0242fc24479fd591d70af2be3e729fc8c45"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "75f0031fe84dcf568f9861bea737734e9ea7f7554c235e0fcfb05faa6c79e31b"
    sha256 cellar: :any, arm64_tahoe:       "4701218c8863360eb7cdb927f219029d5eba0810af1810b16443a347e7814832"
    sha256 cellar: :any, arm64_sequoia:     "d41b5733cebf3f2b45b5ba87b5eb18cd5eb1c5f25811f912bbb39c677a4195ab"
    sha256 cellar: :any, arm64_linux:       "efe208ee3ab5c8c2fa3174ec851cf11ba6c169f1db97caf8d468be413e8793c2"
    sha256 cellar: :any, x86_64_linux:      "c90e0d44cd73649ec5e71bd60bdbcec26d924e3b1d1d6e3906a46268d1b551da"
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