class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.101/ortp-5.4.101.tar.bz2"
  sha256 "fe68267f69c326cd1d645bfdb84db34cd71058e3684f489f434bacd2b9e6ee04"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25ce81c9d6a37d19b45e7a10f966dfe28af89580b469777804db975370e36f67"
    sha256 cellar: :any,                 arm64_sequoia: "721943a278ceb7d26534c3049df2c2ce6dd3780d76b46ecc4c7e5093fa132b4a"
    sha256 cellar: :any,                 arm64_sonoma:  "a49685f8117e151900af15bb6957ed87e85ddb59dcc4aa4c3e7e1ae4dffbd84d"
    sha256 cellar: :any,                 sonoma:        "c53f2db64c28ea6c36733f7acb44f7bbcde9e6cd10e1cda823c6f9dc637ebf12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "813ff8f711480e3358223e619c41dbc3db21bdeae5dc62aa8ceb52107dd7f66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bf04d3f7d24ba03683013b309d8ab2a7e81a6b13fbd4287af280ecbd12a15f4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.101/bctoolbox-5.4.101.tar.bz2"
    sha256 "92f57f484a416b221422befec1f844ba1119f0d0677f39315be4ca5618c2a2e7"

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