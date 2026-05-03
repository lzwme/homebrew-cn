class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.110/ortp-5.4.110.tar.bz2"
  sha256 "559f4153078fc843ed539e738b81b799676b9221ec69dae3dc577fbfbaf40cd9"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "849e40918a8628b462962055d99b8204cc0ae46eb127cf59ca3e610f3eba70e9"
    sha256 cellar: :any,                 arm64_sequoia: "74e0ac0c71fe0ad9369c8b2ed8985ce8935e36b52c3067edba9c4980e1cb6bc6"
    sha256 cellar: :any,                 arm64_sonoma:  "3ae53642473ca9c47e5acb56e791ca0e4a4c2a0314b735436eb6f9cf9ed89271"
    sha256 cellar: :any,                 sonoma:        "3fed6d4d3648d75b94517012e990d5ee5f443dab542196efd97bc0894979916e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382ba89dd77f2bb64dbe3ca9ac6abfe8a25060cf556ff473ae90eb9adb6b4016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eecf8304538c3f9789564e7f5a89b7b01686472f3491f7765791f83b15a9460"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.110/bctoolbox-5.4.110.tar.bz2"
    sha256 "5bccd2e5d850d122948b28f50614d70caaa066f32d6d22a03dd6394c7b26c7fd"

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