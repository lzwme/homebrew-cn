class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/openmp-21.1.3.src.tar.xz"
  sha256 "a3f6af3d9e80ec6217e92675d4253db85f006d788943b8ccacf18bde23d2b816"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d22b0ec6f21b9fa1ce2fe4faf1d4fa0763e9e67f2f34c785ea3d373a3e8b6c6"
    sha256 cellar: :any,                 arm64_sequoia: "7a8b28fff8a9400af493cb5b703bdf2bc98f880761f1555ced736a0417a63b03"
    sha256 cellar: :any,                 arm64_sonoma:  "f816b1fcbf5dc9ab550669bfaa88113b0e5c832c6a92859b1db4d5faf979655c"
    sha256 cellar: :any,                 sonoma:        "e2c69b6ea5127ddb60490b0d0896d739205d12acff892db611c0131ec95cf0e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4439e662a2183a02851676229f93d35efc30619a75553fac1ffce28072f26f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9faef7b7a97513c44b16835efab93269057bf095963ad7e4949395db2497681"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.13"
  end

  resource "cmake" do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/cmake-21.1.3.src.tar.xz"
    sha256 "4db6f028b6fe360f0aeae6e921b2bd2613400364985450a6d3e6749b74bf733a"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "cmake resource needs to be updated" if version != resource("cmake").version

    (buildpath/"src").install buildpath.children
    (buildpath/"cmake").install resource("cmake")

    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "src", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "src", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *std_cmake_args, *args
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