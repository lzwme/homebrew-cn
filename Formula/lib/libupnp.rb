class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.6/libupnp-22.1.6.tar.bz2"
  sha256 "6ca8d4545e818ad160a71d16ec83f4f21f0850a4108b2ae1aff7f99fb85d7a14"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "509d3b1072fe3c59be6c7b529be97d43f02fbfa24717b0c24e0f819b6f605d04"
    sha256 cellar: :any, arm64_tahoe:       "d231da4046e104f141e1ef462e76888b797cabf74a8774b7730e66f52741fa2a"
    sha256 cellar: :any, arm64_sequoia:     "fc87e0a97a3cc10902b565ec01964d9438a56394797c607d90658bdb8faa1555"
    sha256 cellar: :any, arm64_linux:       "f3433c53db60cc1695549a540709f62138bdecfbd4ccf27a3c56e40b41d0c8c3"
    sha256 cellar: :any, x86_64_linux:      "3aef7472a3e8eed05da079bf1b53d0f21e514aa31d594c7f791b3947b1184a8b"
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