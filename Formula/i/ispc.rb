class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https:ispc.github.io"
  url "https:github.comispcispcarchiverefstagsv1.22.0.tar.gz"
  sha256 "38b0e2de585838004aaa1090af12c2ad20a5ee05c620a686979386450ba0c9c9"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a53fdd3b0aebeb740244025c9daa572467f42403d6b19bbf3d5066b4cb9148db"
    sha256 cellar: :any,                 arm64_ventura:  "8bb18c66e3e8d7fe2aa995567631deed8c3020bf6400d8572565b91af267efb6"
    sha256 cellar: :any,                 arm64_monterey: "ca18a541e1979a0bbb66df754f29d9e3060d2272b892d691ba1738d9500c7838"
    sha256 cellar: :any,                 sonoma:         "cfecd1289779a3b393738e6e04137f99f2af5ae50191b949408c2be555d55bf1"
    sha256 cellar: :any,                 ventura:        "3a268edfcdf05648e6cfe12bf77e4e04d4bded8a67fae4d94f973ac0e071fbcc"
    sha256 cellar: :any,                 monterey:       "e2d7744cc1a65867ddf207d1d906467aef2de8588355a1887b41ce265b0357b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca029f7573e647b87b98491feb0f0baa99cdc3a7b8210a5e400906158d93ce0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.12" => :build
  depends_on "llvm"

  on_linux do
    depends_on "tbb"
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Force cmake to use our compiler shims instead of bypassing them.
    inreplace "CMakeLists.txt", "set(CMAKE_C_COMPILER \"clang\")", "set(CMAKE_C_COMPILER \"#{ENV.cc}\")"
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_COMPILER \"clang++\")", "set(CMAKE_CXX_COMPILER \"#{ENV.cxx}\")"

    # Disable building of i686 target on Linux, which we do not support.
    inreplace "cmakeGenerateBuiltins.cmake", "set(target_arch \"i686\")", "return()" unless OS.mac?

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

    (testpath"simple.cpp").write <<~EOS
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath"simple.o", testpath"simple.cpp"
    system ENV.cxx, "-o", testpath"simple", testpath"simple.o", testpath"simple_ispc.o"

    system testpath"simple"
  end
end