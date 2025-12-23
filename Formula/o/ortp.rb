class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.71/ortp-5.4.71.tar.bz2"
  sha256 "b72f2573cd108e77a293afc8d953cddcb4c07bf02065d1c995facbe722fb9bdd"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8783ce43841d9e84dddee9d5dd9464706540efc5cdf5541463dbd960dfa2a88c"
    sha256 cellar: :any,                 arm64_sequoia: "ebb3dd8138d85486c3537af3516faf9118f932fa8e30f113470c653cd1034c5e"
    sha256 cellar: :any,                 arm64_sonoma:  "f12e8cac38935b4a297058e2130cf7867b22427e0ca64fedeac60376d7812d1e"
    sha256 cellar: :any,                 sonoma:        "42377a9748241ed15396e0e1eb57315c90566af3ac5084006b63414cb74f239b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd27cd1b91bd08fe7a91a6c80b341dd1b333401610cb8c1ff87ebfdfbc4bc408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaba57bfda78bce4c02bea8f1916e2943764407057a87a7f330dbfdde534f352"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.71/bctoolbox-5.4.71.tar.bz2"
    sha256 "8d896e87acf5fcb2b5ce882aa5958da2d018dc57b8c06fda6dd7695dbb45b5d3"

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