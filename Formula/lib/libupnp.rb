class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.5/libupnp-22.1.5.tar.bz2"
  sha256 "6fca8477d885ec5b7bbc81cf3d21cd36ff5a24da925aa8e86a44e8a20f2da67d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "93766f59ed8d242a009904301fbfc5eda342a050b326d961122fb0aec6fdb2bf"
    sha256 cellar: :any, arm64_tahoe:       "2767106b737dfc549ae76974523544b67ca59b753eed315c3366da72f931c0aa"
    sha256 cellar: :any, arm64_sequoia:     "31c7b338942668673987f602d9ae2cc873eff7b234f106505bb854a7f0dc9847"
    sha256 cellar: :any, arm64_linux:       "cad27bfa9f4ca2d8775f611b075e7b9095b67655fa10fca4d9512b2b69635a15"
    sha256 cellar: :any, x86_64_linux:      "a8cd161d11469b489de5198f1d527de0def88c2c5e5446b79d0014d885f46272"
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