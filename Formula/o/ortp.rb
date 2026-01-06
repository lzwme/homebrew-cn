class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.73/ortp-5.4.73.tar.bz2"
  sha256 "10834ec5e2f47cc4c4ae32fef9378de2e159260be29aeb0fe7ef3d7895e36ae6"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6019fbcd78169ec4482720b33a1a3b3143b04e29edf1f1b2d462a1b51d651b17"
    sha256 cellar: :any,                 arm64_sequoia: "0db116bd53165a806abc18b1965ce00bc985e7b579dca6953f766d764a8c1150"
    sha256 cellar: :any,                 arm64_sonoma:  "29d09d83d1c2b51a01900e96c440cf710ba93e3183c648c0ff0f93f9029dc34c"
    sha256 cellar: :any,                 sonoma:        "6a43e3d21700424d06c9cce17cf462da5e912b235e802eb8cd4f45ac21566d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80b6b2c99b9424041d9616b6d3d660a9f16b0b26de1985eda00f746c97bc54ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ac2088140bfa251fd8f693cb57cb7a51bfde3c45e95756088a358976857b20"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.73/bctoolbox-5.4.73.tar.bz2"
    sha256 "b39da7109fc25f7d0e0e03aedddbf0a374207367f884ee07ab41851b9949ecd4"

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