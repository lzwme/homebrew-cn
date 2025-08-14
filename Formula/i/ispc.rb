class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://ghfast.top/https://github.com/ispc/ispc/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "207a0552d184c65f3d971ca4be8b53b4f25ebda843df0fc893569ce0b7f07043"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e87b28254925524504f62c40db1cb09c4ce922b97a489d904c222655b70f4216"
    sha256 cellar: :any,                 arm64_sonoma:  "fd18a7344087f35316fc39c8c0c254884a7329865c09b2fe66f5ad6baa9ba064"
    sha256 cellar: :any,                 arm64_ventura: "5dde22fbc1cb48f9587271df0a81df3aa1479dc0c393ce42a3c89017d8938353"
    sha256 cellar: :any,                 sonoma:        "43b272fa3f1cc2bd73b14cc5fda9f979ae37523d508b6cc9074b5103cd8afc13"
    sha256 cellar: :any,                 ventura:       "47a7f98f565cd3a5506d3c9597bc01f4503779c7cebbfdd3ebc1850ad136fd67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa38595f6b4980e2f11944f1949b57ff782e4d29c6170cff4654660ea47a835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2ab8a0339a6e7c424955934160abd9b911c74f24217b242fa5905911848cf8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm"

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