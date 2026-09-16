class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://ghfast.top/https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.4.tar.gz"
  sha256 "d416b95ded205cf083c0c630767b522beff18d98a3f8066970e127ef129410a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "049ddc7ee2e652aad7fc6adf5e75a5af1332b67aeb73eb7a5e269f45f776d218"
    sha256 cellar: :any, arm64_tahoe:       "6772e0d8689e314ecdb8c2e55f2b299cf496fe3d9de8e6bfb7bf5eb0b0dae8de"
    sha256 cellar: :any, arm64_sequoia:     "26d3cd7c47133fdf1f091382de21877a1ab9e8ae3d2112e3c08effa10b1701c6"
    sha256 cellar: :any, arm64_linux:       "1cb5e3cbb8f9b04c977f6940d20320233866526e6341a95ec457a24c0ba65323"
    sha256 cellar: :any, x86_64_linux:      "c566117dbb432da1285ae1d994bcd1978d7b5019baaa01d523a238cd7ae0069c"
  end

  depends_on "cmake" => :build

  def install
    # The library contains multiple implementations, from which the most optimal is
    # selected at runtime, see https://github.com/aegis-aead/libaegis/blob/main/src/common/cpu.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <aegis.h>

      int main() {
        int result = aegis_init();
        if (result != 0) {
          printf("aegis_init failed with result %d\n", result);
          return 1;
        } else {
          printf("aegis_init succeeded\n");
          return 0;
        }
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laegis", "-o", "test"
    system "./test"
  end
end