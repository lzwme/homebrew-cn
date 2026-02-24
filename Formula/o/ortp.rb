class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.88/ortp-5.4.88.tar.bz2"
  sha256 "3898a864f0dad336fa3d708f56c34dca364830bbd1a20787a2ecc67d1026bf3f"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70760a39bda6f0d81dd25e0e4dc17f829c4061fc60bda363b9d9c30ca6f20d91"
    sha256 cellar: :any,                 arm64_sequoia: "6c08f82f30bc32a4cc487e5518be807948c833ec8382a5f8146e51786409807c"
    sha256 cellar: :any,                 arm64_sonoma:  "7e5fffdf6bf31bdacc61bd6e2ed476f885da80c8894ac80a3e15357c72d80824"
    sha256 cellar: :any,                 sonoma:        "4230c94b7c7ec07eab2591140b85e471c51426ca9aa9dc2561531be63f34fded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c18ae8a74f07880f15f32b224ac80e476a46399571c0e0dc243ebbf4ba557b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9223a6ec4f134118ed36b72bd3d23f57c667f4f8081f9cf1d7b14a62b04057c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.88/bctoolbox-5.4.88.tar.bz2"
    sha256 "db130e33ae383360899f5597f295e2b01494a5bed467829d3234ed567abc4a51"

    livecheck do
      formula :parent
    end
  end

  def install
    if build.stable?
      odie "bctoolbox resource needs to be updated" if version != resource("bctoolbox").version
      (buildpath/"bctoolbox").install resource("bctoolbox")
    else
      rm_r("external")
    end

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

    system "cmake", "-S", (build.head? ? "ortp" : "."), "-B", "build_ortp", *args, *std_cmake_args
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