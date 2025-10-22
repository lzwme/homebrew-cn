class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/openmp-21.1.4.src.tar.xz"
  sha256 "0d26bddb78b6fa62ea5181dbfc0797f4548368a9533b20f310156443acc187c5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "451dbdaaaa92dc5fa9085df5e8d14bf51b84739762df0fb0fc6bee5fde3f14b1"
    sha256 cellar: :any,                 arm64_sequoia: "54090f208c0767974f9dec5b3bfdedaa2298b0a9ce5430ed3e8c18f6eb22b1bf"
    sha256 cellar: :any,                 arm64_sonoma:  "991b3f2c7c4db995b6af44aaab2d4bee7a76245646553f4c340742a967bd628e"
    sha256 cellar: :any,                 sonoma:        "d717df409e4ec1543649bc0fddc96acdea52d9696b5c66038e1269e435b29ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eedc5eb587e17af925c4cbfac1f0fffa74c0694868457a987e9d1321c8ca522b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a53ceec2b13406c07db76a318c1db908111ed9de6ea9925a89a3bea845a5dfbc"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.14"
  end

  resource "cmake" do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/cmake-21.1.4.src.tar.xz"
    sha256 "f4316d84a862ba3023ca1d26bd9c6a995516b4fa028b6fb329d22e24cc6d235e"

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