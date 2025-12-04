class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  stable do
    # TODO: Switch to monorepo in 5.5.x
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.67/ortp-5.4.67.tar.bz2"
    sha256 "1cf5e5baa1fb8f469b19025429e7cf248b9e15516dabbd95c9e009d9ede46f4f"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.67/bctoolbox-5.4.67.tar.bz2"
      sha256 "51ae4f9400d6553ba735c27e10e5fc78c19c699f533e0d6a0aaa75c2fe4327e7"

      livecheck do
        formula :parent
      end
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a982a18b02b6fa6d99b62843f70fadf6e1c87b67fb45068fdd96f5ef056b0f71"
    sha256 cellar: :any,                 arm64_sequoia: "a81935b5a6add381677d0c203d327f4c1d6b268fbb82890b8486c5d563d097ce"
    sha256 cellar: :any,                 arm64_sonoma:  "e55b2d61ae73f6a7f22bab9176b409e734b99c98371e8171a65a1126513c41ae"
    sha256 cellar: :any,                 sonoma:        "c5ca156a476ae045ffea84d8ad8f2f6a30f6f0194723ab77ffbfc08aef3be086"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "788e9b7f8760c3fdcd2f36ef730a15bbe5c0011e1ecd48a552ed16d281b0db77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc73c8b05e6f7eb38a6af3fc945e36fa80de42115dacf769326be7f7bd91c19"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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