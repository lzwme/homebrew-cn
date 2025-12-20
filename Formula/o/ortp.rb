class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.69/ortp-5.4.69.tar.bz2"
  sha256 "f00808e19d8d9d91e8535254c5fc5159d0d4973bccfc2a3e5498eb23b2be6147"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "082177100a87047627417d37b56ae75c5d5d66e472945b09e0674bcd476496c6"
    sha256 cellar: :any,                 arm64_sequoia: "ba8098828babe1fcfb63d25bac3c50feab403c145aceb456205510c8c39925ee"
    sha256 cellar: :any,                 arm64_sonoma:  "9906c2574e1de3ad0b9e252dd8b03196765dc2b46c8317745d06bf18c2f78d2c"
    sha256 cellar: :any,                 sonoma:        "14c704cb0e11004b1eb864abeb07faa703d314c7356e4319d30b8e8cb77aef81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2706d780df1770bf91fecf82d34038ddcba47c2a63b033e1bfc912c855d11af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25db5423b2c2586fefc24063f9ce9a1305c9e2929383513f7ec9acbd667e202b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.69/bctoolbox-5.4.69.tar.bz2"
    sha256 "23059194f633581c268cf79cb5a6b338273e89889c5e3be9c94aa8c90550294f"

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