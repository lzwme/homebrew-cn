class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.2/libupnp-22.1.2.tar.bz2"
  sha256 "9eb5fc1e9a91dfcedf079700ef4a9fdf48dc15d5c6802360c16a6118e0a07b08"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5383a28639268b256142699cffdd38cfbfa6f2840788f62236b81e783620da6f"
    sha256 cellar: :any, arm64_tahoe:       "934cc64fe38c3873ba9d54cda34b17b0699dba43ad6db7c78ef1ee1d1825ebb8"
    sha256 cellar: :any, arm64_sequoia:     "e9d52783c42534f30ac3d4503bbd51da6da1f6850d3597d4340b8756d72607f9"
    sha256 cellar: :any, arm64_linux:       "c9f6d05ba41861b4a150aa7f6a9f539824e09b113daf33a7e35ed2781c3101ac"
    sha256 cellar: :any, x86_64_linux:      "efeef06db86b79de44f42ab31071a1a253b7dcc8b95f7b68c43ffe1e9b156fb4"
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