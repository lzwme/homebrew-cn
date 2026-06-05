class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.119/ortp-5.4.119.tar.bz2"
  sha256 "58c1a0cba0f70ad58d8f3bc62e76646b830e5e8eb4fdcd09faf55681d49f197f"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d24605c1b906945e00a23458ff0b5d750ca025fd993386747e9456a3eba4f85"
    sha256 cellar: :any, arm64_sequoia: "6c157e7e2c26776e7e07c3b9a79f0e7f7e5fc25a22bf9eda95dc59aca07e7033"
    sha256 cellar: :any, arm64_sonoma:  "f6c558a1bc8a3c12c4983d88d1abfe648b3876cd5b8c45ac9b03cf4ee495a3ad"
    sha256 cellar: :any, sonoma:        "9ef0e524f2232de6fed39e85f62cc3e0ceff46ac5e31c39008f209f0d5fc5501"
    sha256 cellar: :any, arm64_linux:   "766ba5fd1eaf186ee2fde2892ce0bace79606db8c652c067c192b4f6bd4737e3"
    sha256 cellar: :any, x86_64_linux:  "321a0b186c0c5a19732b9b46dca06bd8540fe1927a318dc19a989295281ab1d6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.119/bctoolbox-5.4.119.tar.bz2"
    sha256 "10041b583415f2fa1b89cd021a3eeb34e560e9da197f2726de6d650c637f5a17"

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