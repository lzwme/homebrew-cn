class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.8/libupnp-22.1.8.tar.bz2"
  sha256 "4c50d3f3364021f6a6c70ab84d04bcd6f440654321a353cf644dc0cd89e5fad5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0423896ec47e9bf5d374138cf769f3365dc7f24a9f0164de1b959e49afed685"
    sha256 cellar: :any, arm64_tahoe:       "d3fbd62e79b1992642782911159430ea3919dbd1c5422db0d782058e0689b88d"
    sha256 cellar: :any, arm64_sequoia:     "46dc0c4e5e96d27d9cfb2b88d619b2372e83b9b2da03dcfd8ecf7b90ad26e4a8"
    sha256 cellar: :any, arm64_linux:       "1be148c74c05d8cc453bb43a3408ed8b73a7cafbde6651b05da5996fdddfa0a2"
    sha256 cellar: :any, x86_64_linux:      "cc3ff88c249432cf75e6e6c4b1ad8878b89f2fbe77b9cc2e2914d09de845c049"
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