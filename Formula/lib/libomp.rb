class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https:openmp.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5openmp-20.1.5.src.tar.xz"
  sha256 "13f0ffac3875263a5d771cf1eee10a981dc14c98b9362fb978a1ff201f147930"
  license "MIT"

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce551dd086cafa0fff95f445829cde286c1389b1bd2d87b3571c54d7e02b25e0"
    sha256 cellar: :any,                 arm64_sonoma:  "c281ee6eedb8cee7e962de881f85e895b561abb88f017eeef17f6eedcb63540b"
    sha256 cellar: :any,                 arm64_ventura: "b034992d5945b44af8d54bfd6c0db769d9f63e7ef8d818b1200d662c886ccd53"
    sha256 cellar: :any,                 sonoma:        "70c9db59259c9837e3e604de7e73c1a94bd8ebd47aa890511fe644f5196819a3"
    sha256 cellar: :any,                 ventura:       "9972ac42bb91dfc33cdb758ec929c6f1ac01cf9abfbede106dbc5cbe1046192b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffde618f729558dbe6e2b1bdb653959498d8a85b365c2540ca4646de63233df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c36192cf3628d79a752d63f94a90d02e5e66518f1c0a39365f77f92d1f60ec"
  end

  # Ref: https:github.comHomebrewhomebrew-coreissues112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.13"
  end

  resource "cmake" do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5cmake-20.1.5.src.tar.xz"
    sha256 "1b5abaa2686c6c0e1f394113d0b2e026ff3cb9e11b6a2294c4f3883f1b02c89c"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "cmake resource needs to be updated" if version != resource("cmake").version

    (buildpath"src").install buildpath.children
    (buildpath"cmake").install resource("cmake")

    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "src", "-B", "buildshared", *std_cmake_args, *args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "src", "-B", "buildstatic",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *std_cmake_args, *args
    system "cmake", "--build", "buildstatic"
    system "cmake", "--install", "buildstatic"
  end

  test do
    (testpath"test.cpp").write <<~CPP
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
    system ".test"
  end
end