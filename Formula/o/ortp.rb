class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.74/ortp-5.4.74.tar.bz2"
  sha256 "7c5e022c049c068fb1e522d58e612b7fbe343307a71fc5af7f3a10a77b61fa4c"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "011fef62ca3ea0d0705b1431a511d1a818b07e70faaffe9007fa414de6330c43"
    sha256 cellar: :any,                 arm64_sequoia: "6c72a16a808043092c5dd300f12b2ee0e2eb50d227116a357239020e92e6c5b5"
    sha256 cellar: :any,                 arm64_sonoma:  "4298f0aa527cb5d1d50fdca6b4b723e84b6b6d3752a149e3384d94a535f5f218"
    sha256 cellar: :any,                 sonoma:        "332e9a66f6d23224421fa5c59733e339b5ceabd17f6f55df243083570f6a7c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "772e02baac8ef27381c490a153de8de159ea68964b103f10c3fae835ca0684ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a033c90cac6c5ebe3e45df9ac2263274067247f634bb8bcf6facb105a5627385"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.74/bctoolbox-5.4.74.tar.bz2"
    sha256 "11443cdaab9bdf2cd6ef139d7d0b0d87e5f6cd163fdc464d6e2990538b9fff4b"

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