class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.110/ortp-5.4.110.tar.bz2"
  sha256 "559f4153078fc843ed539e738b81b799676b9221ec69dae3dc577fbfbaf40cd9"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f727fff16b99af99795dadf765d5006945b38afd376cbe626022b00e72109791"
    sha256 cellar: :any,                 arm64_sequoia: "a8ad22cb3135eea7d47fc0e0c36035d2084b1affd70f99199727e950d53d8ed3"
    sha256 cellar: :any,                 arm64_sonoma:  "39505f0bed2ca691880d39469f3577074d6a7334561b5919ff946f996f7d7782"
    sha256 cellar: :any,                 sonoma:        "c2a5274a67d9e5a577367654a36289088bb755f56529a56c7cb7566737403f43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7390d9f4f4353ebd928e1d27cd8a34be8a6b13a7a0fdd3ed1540420ad0c34132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "877ff7f0f9e9c92ee54a86ac79f7ddc1ac314d0e8715f94fb464754e34fbe506"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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