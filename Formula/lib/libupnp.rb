class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.7/libupnp-22.1.7.tar.bz2"
  sha256 "428af5e0befc6d4a41179966f828595a5b48ea0382a64699b71b08b900c397ed"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e6a489d9d1be063ebfd0bf2ed45644b1488ddcef79130b7891ccaf3142356c90"
    sha256 cellar: :any, arm64_tahoe:       "458d179fe806d44d38806909a7aa78605cfae449a9e24bb62b077136637ba091"
    sha256 cellar: :any, arm64_sequoia:     "fea0ce9346849b1ded92e726f1da348aae0076a4399b0231fcc744626762c09c"
    sha256 cellar: :any, arm64_linux:       "ada42f33edab000ab7d8077b472ba102fa17617e218dfaf75279646d1a1c02f7"
    sha256 cellar: :any, x86_64_linux:      "557258ce11853adb0c120a13b98449d9691a83f3d1474007f6027499a05f8176"
  end

  depends_on "cmake" => :build

  allow_network_access! :test

  def install
    # https://github.com/llvm/llvm-project/issues/65557
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "upnp/src/genlib/miniserver/miniserver.c", "switch (gMServState)",
                                                           "switch ((MiniServerState)gMServState)"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUPNP_BUILD_SAMPLES=OFF",
                    "-DUPNP_ENABLE_TESTING=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <upnp.h>
      #include <upnpconfig.h>
      #include <stdio.h>
      int main(void) {
        printf("UPNP_VERSION_STRING = \\"%s\\"\\n", UPNP_VERSION_STRING);
        int rc = UpnpInit2(NULL, 0);
        if (rc == UPNP_E_SUCCESS) {
          printf("UPnP Initialized OK\\n");
          UpnpFinish();
        }
        return rc;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/upnp", "-L#{lib}", "-lupnp"
    output = shell_output("./test")
    assert_match "UPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end