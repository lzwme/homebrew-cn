class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/ispc/ispc/archive/v1.20.0.tar.gz"
  sha256 "28a1de948fb8b6bbe81d981a4821306167c64c305e839708423abb6322cf3b22"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "642ebcde4c69fe8037c74281ea26a75b95fd2afd0f382c4dd8c5d3cd938dd100"
    sha256 cellar: :any,                 arm64_monterey: "a6a32ada2909684f9ae3b21306aa1ea0042bd5caad04bf375c8d08b940e4ec1f"
    sha256 cellar: :any,                 arm64_big_sur:  "ac260f46115bd06f5fb0bc41c4cc8d30a3834a390ab38a71d379a3b3539564af"
    sha256 cellar: :any,                 ventura:        "4f697f98ec17ca59cfd9f6028a8c4de4fb53eb8449525587e784cd6c40c902bb"
    sha256 cellar: :any,                 monterey:       "1f71c068679fd604d45dfcb5cd4a9a3575ac7f6bcba879202abed981d43131da"
    sha256 cellar: :any,                 big_sur:        "a115c3b38997b84d9b4ccc2b5dae131db1dbd3d53c31c088c82656ec73d31c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bffe5ff68fc71ff23fa4f5ba00315cc508317d464f0eb086d307deddf5224291"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.11" => :build
  depends_on "llvm@15"

  on_linux do
    depends_on "tbb"
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # FIXME: Set correct RPATH on macOS
    inreplace "ispcrt/CMakeLists.txt", "set(CMAKE_INSTALL_RPATH $ORIGIN)",
                                       "set(CMAKE_INSTALL_RPATH #{loader_path})"

    # Force cmake to use our compiler shims instead of bypassing them.
    inreplace "CMakeLists.txt", "set(CMAKE_C_COMPILER \"clang\")", "set(CMAKE_C_COMPILER \"#{ENV.cc}\")"
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_COMPILER \"clang++\")", "set(CMAKE_CXX_COMPILER \"#{ENV.cxx}\")"

    # Disable building of i686 target on Linux, which we do not support.
    inreplace "cmake/GenerateBuiltins.cmake", "set(target_arch \"i686\")", "return()" unless OS.mac?

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

    (testpath/"simple.cpp").write <<~EOS
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end