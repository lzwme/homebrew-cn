class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.97/ortp-5.4.97.tar.bz2"
  sha256 "83065319fe134a247aa7969b23bcf999728abad45fc7278ebd4df5f237ef9331"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b71ddc5a346a5805aee3cb099cc36c7777f8bd69b11d397a7dc3a6a8c176da1"
    sha256 cellar: :any,                 arm64_sequoia: "b0a3d26afd80035664c885fe1b2b62c41e871bfbb655bc2abad33c6833d29098"
    sha256 cellar: :any,                 arm64_sonoma:  "24683fb9b71668130c822169625bacee085604b27cbcc1fab9e6f58f8db77960"
    sha256 cellar: :any,                 sonoma:        "621e5916ccfde2be4d2587e4ea20dedb2637a2584950126cf2cc1ee14d4544b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "293f21dc686ca4fef7a22ef6a6f80979e774f0f88b920b176619684131b48821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f169dd88c75a027d89720831c57eac3eb457dad98a1a8781e34f3906df8a6f03"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.97/bctoolbox-5.4.97.tar.bz2"
    sha256 "ba47994636696ad3533264f1f286c13617b3a8d33c8edf236e27464e2f8e5742"

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