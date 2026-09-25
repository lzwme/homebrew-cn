class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.4/libupnp-22.1.4.tar.bz2"
  sha256 "ff26dbf59e786cedbffd37192c44042207349fc04680b67ef48a4c2505426944"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a31076ff0e06f061b362352a269a179184a6da88c0f301b6d02e6ee47709724b"
    sha256 cellar: :any, arm64_tahoe:       "d874994662dd6305cb94039bc9a74880810ff932e376279907f6ec698d9ab847"
    sha256 cellar: :any, arm64_sequoia:     "9e11d8df053a7f42eb7b5d151e2651555fd4a1bf5115c38d7370bc19d73ffef0"
    sha256 cellar: :any, arm64_linux:       "67cceb548ff5caf7f8386d18fee2684e032f58d7ad73483164eed592ea2294f2"
    sha256 cellar: :any, x86_64_linux:      "ed99dd2a65208e8d63aeca903b00164d7b4bb4f88e165dd415fe2440c80e12c0"
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