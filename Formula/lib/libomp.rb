class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.2/llvm-project-22.1.2.src.tar.xz"
  sha256 "62f2f13ff25b1bb28ea507888e858212d19aafb65e8e72b4a65ee0629ec4ae0c"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82f432712cb1f241632bfcea9598cd728c7e4e581e49cd3dc3cbb401fe549a31"
    sha256 cellar: :any,                 arm64_sequoia: "2f17e338c69f7d875b22b95e738ea8c3ef5f62fcd0849715be682c1d50cb5d71"
    sha256 cellar: :any,                 arm64_sonoma:  "9f27e4eff9f59796a750ddc868266d484513b9206ad497552bbd3ae143c49c6b"
    sha256 cellar: :any,                 sonoma:        "4573c77b99131736d7bcd4a7fcd7482da0d33651e3b8dd83d89be5ec64e9f8a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33fe5e2b84cec1ff8c626c03acafdf88b1837174f58bc76253ec3132850068f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3b1fe1d7d935ef3ba8bbe2e0a7d1949d557ffe193d02acf49258ecb485e636"
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