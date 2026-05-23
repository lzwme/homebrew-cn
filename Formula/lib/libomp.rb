class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.6/llvm-project-22.1.6.src.tar.xz"
  sha256 "6e0b376a1f6d9873e7dfb09ae6e04b9c7024400f01733fa4c29be69d5c138bc2"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "335925f0e6a519cde14d7bbd272a1282ebfce553c6793ed460fd5a96f55ada93"
    sha256 cellar: :any,                 arm64_sequoia: "d6214033c8be26a5b8f3f6b2a439e6c4f9f5eaacf3cc6b19880706309bac0444"
    sha256 cellar: :any,                 arm64_sonoma:  "841387d76048035c83ec28dd274c8c38799ed99ec2129345fc9d2723db47ceaa"
    sha256 cellar: :any,                 sonoma:        "ba8193ea264dc2cb5652cca5baaa4c020a75c137fff691e7687fffb3a2f13cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0bc67cef1d8bd444d9368d5597a84ceaa26f189fc0de0b587cf36db65edeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c768c44c6a51f3b082765b5ffdb5f52e795fc7b4171182222a693522cc63cf"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.14"
  end

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = %w[
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DLLVM_ENABLE_RUNTIMES=openmp
      -DOPENMP_ENABLE_OMPT_TOOLS=OFF
    ]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "runtimes", "-B", "build/shared", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "runtimes", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
    CPP
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end