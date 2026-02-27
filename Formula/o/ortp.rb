class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.91/ortp-5.4.91.tar.bz2"
  sha256 "1842f5cbc90a58c23b3dff2cff2560d896e21f99b88314547cf9e1f34e8f653c"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "72f181085684c47a6d7e3ccdb699a68fdea06e848994750c0870d755c1786f17"
    sha256 cellar: :any,                 arm64_sequoia: "d74485f344364805724dc118ea017cbd457d7b335be67e2ab9f05b64396efd0f"
    sha256 cellar: :any,                 arm64_sonoma:  "de984f5e184439797037e2a16d60e375bad422679bcd2c84bca9912c1555b388"
    sha256 cellar: :any,                 sonoma:        "606d0b7d44489df031657217e84d9047731af82c7df657ee0a6659a0499a765d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc2753bfe4013ce8892003a361635db0ccf3b924a6dd3727588fcbf7255193d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282838a2e03311f2266f7c9632f018c665e9679b28bb2338d72b314be30a15a6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.91/bctoolbox-5.4.91.tar.bz2"
    sha256 "10800f43377e7399f839e12af5ae570b63a1f66e7c97643fc64587809604763c"

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