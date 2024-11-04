class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https:ispc.github.io"
  url "https:github.comispcispcarchiverefstagsv1.25.2.tar.gz"
  sha256 "745cc8bcde26e63af2700f1811b66d2ca66b2844c8e2aa9ac19c12ab6a39b82a"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b0f72091d48f949e719772d717989af9cd169f6f89a890702b0104a02752395c"
    sha256 cellar: :any, arm64_sonoma:  "c7a09a3f7c4204420de15636a254ddac95d3e43fbddcab1aa6b6c85b250245c5"
    sha256 cellar: :any, arm64_ventura: "164b88b15ba40aaa2fa6bf1a48175a0702d07f0f2dd0959f505633d5fd638478"
    sha256 cellar: :any, sonoma:        "7945def3908530673b9e6e3b20484734613ed5716180c0d080f8142eff99c329"
    sha256 cellar: :any, ventura:       "2d802a069f6014fbce7666f9ed2bf5fa978c38d4fcd3445fd3ba2b4b4b7de308"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "tbb"
  end

  fails_with gcc: "5"

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
    (testpath"simple.ispc").write <<~EOS
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
    system bin"ispc", "--arch=#{arch}", "--target=#{target}", testpath"simple.ispc",
                       "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath"simple.cpp").write <<~CPP
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath"simple.o", testpath"simple.cpp"
    system ENV.cxx, "-o", testpath"simple", testpath"simple.o", testpath"simple_ispc.o"

    system testpath"simple"
  end
end