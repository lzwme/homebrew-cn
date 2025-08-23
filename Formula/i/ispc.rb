class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://ghfast.top/https://github.com/ispc/ispc/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "207a0552d184c65f3d971ca4be8b53b4f25ebda843df0fc893569ce0b7f07043"
  license "BSD-3-Clause"
  revision 1

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "712267cbcd1d9ccf7945f8ead6702067e6663b4c5006982045c67c9902e3d83f"
    sha256 cellar: :any,                 arm64_sonoma:  "30f8f5032a40279f5ad8cda3e786771a7a33d0c759a3d73d9a6e1dd32e92588f"
    sha256 cellar: :any,                 arm64_ventura: "fa2dda37e14d6ab496a3f1f2703c5ba0e18959b7e3b29337cc53755e330e071c"
    sha256 cellar: :any,                 sonoma:        "0e1ac09de1832ec69ffde6e885e902271b83973b31a15f00119f1b70b4b41b30"
    sha256 cellar: :any,                 ventura:       "798bed2aeb38cc4e7008add47c267f3149ed4b383031dc32480a3795e9158048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce5b72785e2c3a0d6de3c004d8199e7b05e77aa19d2fc28f9dedee2cac8d6e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d55df7677ad255f667ef148dafe9bb66e836b706f55faff618bb92de4bf2d7c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "tbb"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    args = %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR=#{llvm.opt_bin}
    ]
    # We can target ARM for free on macOS, so let's use the upstream default there.
    args << "-DARM_ENABLED=OFF" if OS.linux? && Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"simple.ispc").write <<~EOS
      export void simple(uniform float vin[], uniform float vout[], uniform int count) {
        foreach (index = 0 ... count) {
          float v = vin[index];
          if (v < 3.)
            v = v * v;
          else
            v = sqrt(v);
          vout[index] = v;
        }
      }
    EOS

    if Hardware::CPU.arm?
      arch = "aarch64"
      target = "neon"
    else
      arch = "x86-64"
      target = "sse2"
    end
    system bin/"ispc", "--arch=#{arch}", "--target=#{target}", testpath/"simple.ispc",
                       "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath/"simple.cpp").write <<~CPP
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end