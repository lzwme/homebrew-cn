class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.116/ortp-5.4.116.tar.bz2"
  sha256 "f5e234199a86c435fe4fb99688ae541e0428d3b19b0783f3c1c37e830304e4d0"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4ce99727bdbb2d251d0d29774af58012b5be6ab835b66c0d9c2c14ac2fe5ce5"
    sha256 cellar: :any,                 arm64_sequoia: "0adc83417c3b8ce13dec5f4139ac8208b92412d0a91df0a22201d72fd9198a21"
    sha256 cellar: :any,                 arm64_sonoma:  "ff1307e7ad45702203e89846146de488831efb0a51b8b83287f7635901d93376"
    sha256 cellar: :any,                 sonoma:        "106af3521c6d3fbc341c2904b68802c38dacaf1d53332a1cbb534df663bbf6a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "199d60be5204c5f1f5aa2fd38ab12630e13ba87165d3e649d610aa50d7c54c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6bb87771b4cdfe4f53a6d32c475a3f8cf46ddd30045a42c850d13ae5f53174e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.116/bctoolbox-5.4.116.tar.bz2"
    sha256 "0e8f7b0d3e3b8a1b018f42ec601bd9cd7197d4ceb026212d30fc3d5f8232cb5c"

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