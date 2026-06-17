class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.4/linphone-sdk-5.5.4.tar.bz2"
  sha256 "b9ef0b4b975b1273d6b4e4ce221621bb79148d3bae67bd2d3e51de18e37418d2"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "86f85b98b5e7433bed89dc7eea531546cea1b91546056a78b4dd4d4d49ed0ddf"
    sha256 cellar: :any, arm64_sequoia: "dc98b7d14212b8fa6cf2654f03b8b863dd19c58e26ef1c8b12af611734ae3c69"
    sha256 cellar: :any, arm64_sonoma:  "459ffff336980d36fcddff671af8afc99041cacfc6b1ed885f446a90a97dd557"
    sha256 cellar: :any, sonoma:        "ffe151c67d09b6d2254975f70a7e0b56d4f725703a4758f53646de354d012992"
    sha256 cellar: :any, arm64_linux:   "2e2dc14a1677d179f59de995969cf920b9796fd5a116b3ccfb0e4966a63f0db2"
    sha256 cellar: :any, x86_64_linux:  "471875d224027f9d177d4cf1b9df26769a44074f8eb5234c5ffad8eacefa2577"
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