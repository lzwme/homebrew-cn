class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.105/ortp-5.4.105.tar.bz2"
  sha256 "11945a38b2fbce46b58dcdc46a2978371ab6a15f0c9c147e3412a01032ee6e93"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "976aec6618cbccf74a2b000e9b22eb0499160295c17642f447a598d88b18e4a8"
    sha256 cellar: :any,                 arm64_sequoia: "be3ddbf526327161d1abbfbe3bbd625015c6a9069cdb9bd7ede42f48a15bba27"
    sha256 cellar: :any,                 arm64_sonoma:  "fee8aa9c9dd94e5ec1ec877761a7b205e5a1eac9bf955660324100a1084f43db"
    sha256 cellar: :any,                 sonoma:        "bc071afacba05a4d063eea2dfd3db0541f5a50653f06bd4c9f1123d742acd83b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c228572fc0ad53247132e27945d4bb894be968f17cb320be4d2fd7c8d531dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a969211651026e8e5af75457897c81730778bf52049c56b842cf47039f1c2d58"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.105/bctoolbox-5.4.105.tar.bz2"
    sha256 "1f549b96e626c0fad503e11e428b453a26e847214aed0d79176cf5ab23faae33"

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