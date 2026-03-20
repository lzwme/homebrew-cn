class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.99/ortp-5.4.99.tar.bz2"
  sha256 "2685ba2af476897d435a8bb7a32fa74a12f45ae397c25fba6b896b4a0817c607"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "616372d19a13a032a95f8a01a294bf1fccff1864d8c3e370f0b6fcba2de9b327"
    sha256 cellar: :any,                 arm64_sequoia: "58e2e6663e9147ae294c6e8dba9c0699210d493b81ef285f1a6579ff11617a20"
    sha256 cellar: :any,                 arm64_sonoma:  "25c3d0127f3253625ec9a23cd399b0034a86e9bf22ad77cdf0935b527d21a3d4"
    sha256 cellar: :any,                 sonoma:        "470a8c24797dd395acec4a6ed7395cd8102d69d886d441e80b92ff02291cc723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba1e04fb807390b6f4825caef1b77206ac2f77a08355122e14e02b411145e011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9ff7756138d2556c2f3a1c530125057dee5a9eff6b0358841f8c95c05f0bbe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.99/bctoolbox-5.4.99.tar.bz2"
    sha256 "60601b9054f3afe7fed8debc6e40da32fefb6b76b08175be056bfd2576d798f8"

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