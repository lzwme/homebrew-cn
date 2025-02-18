class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https:www.sympy.orgenindex.html"
  url "https:github.comsymenginesymenginearchiverefstagsv0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1093eac02a81bf30400cfc0b28194d530ae61368216873af5b9824d2a7100b3e"
    sha256 cellar: :any,                 arm64_sonoma:  "6b9be76401992e79f0ddf186746ff54f2ea2756edb48f0df53f46fac0c57d547"
    sha256 cellar: :any,                 arm64_ventura: "347528d194e04b1e457adc403b70d7a87817246018d21b5045cdcadaf23c4eab"
    sha256 cellar: :any,                 sonoma:        "3396e3a400feb30be0be6bf7baf8fd9ca4614753f551bf206c5a848414df347f"
    sha256 cellar: :any,                 ventura:       "8204889f800fe9b42941140d81271ac3d8fcdf704dbe3e62ea730a51615f1443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50c7116028e7df7b0556e9f256423ccf7705763c783eaef5dd8873958edb291"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_GMP=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DWITH_COTIRE=OFF",
                    "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm",
                    "-DWITH_SYMENGINE_THREAD_SAFE=ON",
                    "-DWITH_SYSTEM_CEREAL=ON",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <symengineexpression.h>
      using SymEngine::Expression;
      int main() {
        auto x=Expression('x');
        auto ex = x+sqrt(Expression(2))+1;
        auto equality = eq(ex+1, expand(ex));
        return equality == true;
      }
    CPP
    lib_flags = [
      "-L#{Formula["gmp"].opt_lib}", "-lgmp",
      "-L#{Formula["mpfr"].opt_lib}", "-lmpfr",
      "-L#{Formula["flint"].opt_lib}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system ".test"
  end
end