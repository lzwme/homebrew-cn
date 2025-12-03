class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/openmp-21.1.7.src.tar.xz"
  sha256 "0f892ed2e85e1a9bc9f55699aec0a5a020c9f0a77ce8d29fb4cdf3aee1b72033"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28d97af7c94b4c2eb352fbb0b1778cccebc26e8250ee0451ec5f7f0083f60547"
    sha256 cellar: :any,                 arm64_sequoia: "863f0c08e4fd74c3e52e85fd2ef421264655af58d4ec495cd1d7fc7b8a1aa77f"
    sha256 cellar: :any,                 arm64_sonoma:  "6b962c120a366eb2d06b1aa295ca5c9b0bd96b35b55ac45a1692381a372ec838"
    sha256 cellar: :any,                 sonoma:        "34d28130318c9ee0334152aa79315ad06a1870e95a7d06e443b05e620839a6c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b09bc6084706a19fef630b89b43fdfd827ded3515e980d1c701aa6ed0d03b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17be136935344d647801faf15d7d6611a0bea65ba15470691e07aa55164af81"
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
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/cmake-21.1.7.src.tar.xz"
    sha256 "f25ca011e4453ac035e940aa729d482d08eb83a91b4aaf1f230dc9ea28cadfa4"

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