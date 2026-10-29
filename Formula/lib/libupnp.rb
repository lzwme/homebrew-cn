class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-22.1.9/libupnp-22.1.9.tar.bz2"
  sha256 "9acebcd6f92c6161cf53c638b6f03ba56eb894893bb75c0894b2fb740822caf5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d65d96f1692783b64dd1f449d906db55264c08a20932b599e5fe1b74db7bd8a2"
    sha256 cellar: :any, arm64_tahoe:       "3468f80baf2c4e6be15e0c5ed80d026c844501f53d27169c28bdace2337dfb55"
    sha256 cellar: :any, arm64_sequoia:     "b04d744456b54c381acd3619fb36297118ce475baf15a0b2a0c4de52fce9c553"
    sha256 cellar: :any, arm64_linux:       "4092eb007291d8137cfa3a50d58866c8a8c7f76faded5b9f1bbafb80a4b54430"
    sha256 cellar: :any, x86_64_linux:      "25282f5c9a728ad0b9c56abe8f0d56824a73e728457c029a9d9e2f146d348d11"
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