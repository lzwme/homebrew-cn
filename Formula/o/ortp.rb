class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.94/ortp-5.4.94.tar.bz2"
  sha256 "35365f9467067f0abdf9d994fe953c9db58995216c3a51abe1f5462bd31125c7"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb90d9e0659171e42e1105ff9fa8a7000ef8a6c005681f3dcc79b1253bac8c19"
    sha256 cellar: :any,                 arm64_sequoia: "0cd738516f506b4f9b90a1f44f57277114830a24b3d1ccf7f6fefb8f69c1dbee"
    sha256 cellar: :any,                 arm64_sonoma:  "a1d66e42ab1d45c740b30e42944ac64bd214c0c00a9d3a1f77a19c9d8bfccf5b"
    sha256 cellar: :any,                 sonoma:        "06fe4771cbb37d1e89a79f74ed56b056a4d990f5bb499ff2f923f8d020e11e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10515506c5228d3b5d1b5178800c1e72ec6df82bf6fcdf208024a8d5172bc0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd157a03dbef6574145f43a873be57b4b570d4266c975bf24b23b7a1c79487a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.94/bctoolbox-5.4.94.tar.bz2"
    sha256 "d010b518e771d94a8f2c3f44a3a5a39a8c04431912d2148a365a874bbfd7bd20"

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