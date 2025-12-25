class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.72/ortp-5.4.72.tar.bz2"
  sha256 "288d9c4dc69ec67b654ffaea8fccbaabcd23ffe66b339dbc22bdd30823bd7f2d"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1c87a85cd070b4b8668b8a83f8ae5a2c50ff5db3a42c43611efa6e226ae0946"
    sha256 cellar: :any,                 arm64_sequoia: "75d521ea3e575342e4b21c7c070d63079401e184d3c91dc4399cd0bb8e2176b3"
    sha256 cellar: :any,                 arm64_sonoma:  "495a3d626a253b3a564f44c7f41ba993e70be4a2cf3dada50c07c7b5735733c9"
    sha256 cellar: :any,                 sonoma:        "342145e4ef2a50463035fcf3fdd30cf8d4df534aa04f1e01f2335d5b82aa7eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e79e0be4784a406e3abb02b26d56cc739c4b318f8b536939796b544de9726d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d93820f1550c79b908fdba6b8bcd745c5049f96b01bfcdd8089955a3cf2bcb8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.72/bctoolbox-5.4.72.tar.bz2"
    sha256 "0008f13e97556ceacdfcea89305bd77f1fd416b46b106a5148f34954b838e751"

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