class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.0/llvm-project-23.1.0.src.tar.xz"
  sha256 "ab1f0e3ec52448c33e8782eaf0422504b87c7b016b22514653ee0d8fcee479ff"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "462a36670e56b7804c607e16c4d1b013bbca2a531b39b612a28d8f1bb0c1a37c"
    sha256 cellar: :any, arm64_sequoia: "a914cb7f006572fe9e04da730638bbfb4a19e4617a1ba07f5b5f8beb4a6481ab"
    sha256 cellar: :any, arm64_sonoma:  "63919c47ac15a3031c77de66ba76ac52fcd068f24faa4038680f60fae1bbdb47"
    sha256 cellar: :any, sonoma:        "4925945ec704f56f229695cf28e8079aaa0b7f554297b8b82a9af7b4815de1d7"
    sha256 cellar: :any, arm64_linux:   "30765b8f66024018584a78a1a169f4980e723a0b072dcb2f2a28f8d6b542f614"
    sha256 cellar: :any, x86_64_linux:  "b6987a1c76376741f6012010fd4fee4696b5ef9167da4b1a1199d165b8917dde"
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