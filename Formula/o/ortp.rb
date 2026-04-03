class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.103/ortp-5.4.103.tar.bz2"
  sha256 "00bf3e47847f73b27eed4194a017d93b8765a5c3f4971d5e129b6d891ccc0a61"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0cd5e18188e4ae0f320c2ce977d19e32fb9190c445066b6cb1355e8518a0b22"
    sha256 cellar: :any,                 arm64_sequoia: "b680695911262efbad7179dcee7406b98af3b3a9a9764db77b80449f4624ea73"
    sha256 cellar: :any,                 arm64_sonoma:  "34aecbc071d31bd7f1f65450da47e58092c0c347c5e896d79519ad2665b8d343"
    sha256 cellar: :any,                 sonoma:        "c41c5b01a15c8e505dcc97717316b929c619e0064dee511a5098f8d0aaf5e3b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09569a2e5cfb9047d01502e88b50c520c3848e6f6a3663d762d6b912de514943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb27d8a53a75cbe5f9029d7031b0cfa7c0ea6e83d40d230f3827efb8c49da72"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.103/bctoolbox-5.4.103.tar.bz2"
    sha256 "29cc99240d5949ab37b241c3965963eab24b5a37e1609c3a7c184f9082abc850"

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