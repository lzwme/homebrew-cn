class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.114/ortp-5.4.114.tar.bz2"
  sha256 "1ee5e1776539214de6422f7e3e674ff6cb1dfda1d48dfbe97b2f5613b0bc2bb3"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1e42f5e0b251a0ca54bb7b76657c819a7fc8d88e8987df94964294b8dbe0b6f"
    sha256 cellar: :any,                 arm64_sequoia: "0c3266e5d99fab3b99bd0c9d4e4bb7450e00818197768569a3a9b9c60cc75515"
    sha256 cellar: :any,                 arm64_sonoma:  "8fde85e8679412eebe9af05f3d8a9cc17e2b1fce15177b63d987389517134b81"
    sha256 cellar: :any,                 sonoma:        "c82c97ea9c1fb7f1218f2037568a80bca892e264555a3674f3e877d25088df1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6d81e947ae95edf6d7699eca9c25a81dd681059209aa623c7ee88b952b3c502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28378e76b888192ee85566205c1357a9189bcc483bafb3e1f34dc35138a179d5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.114/bctoolbox-5.4.114.tar.bz2"
    sha256 "aefa6904d6f1fd524ce104fbd6778ab52409e9a5bbb2eb8ff9eb28dd02f33bba"

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