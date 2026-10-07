class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.30/linphone-sdk-5.5.30.tar.bz2"
  sha256 "ea2ac1c3861eec48b939eee92c1b603843e070be9e730303d529761b6e1d4cf8"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08af98c4cd2d6f1bdee7c43a6934e16db0bd9842e86bdb0e58a40f26c2ca654a"
    sha256 cellar: :any, arm64_tahoe:       "f720e90b25cc130e4afa9c692f56f03eb5f9c55ad5b60eb6f9241732935b86c5"
    sha256 cellar: :any, arm64_sequoia:     "6f35d64f9d5adb70b5a8de592d110453c7059d19b4c81c034371cc31819a87a8"
    sha256 cellar: :any, arm64_linux:       "eaeee32cd5510278de14afeeded534545dd73626784a0ee2a583f962f4e1fe9b"
    sha256 cellar: :any, x86_64_linux:      "588ced966cc58a45c3aea9165c18be6839282d97e8cf2439206fb2661159971b"
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