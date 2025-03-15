class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https:www.sympy.orgenindex.html"
  url "https:github.comsymenginesymenginearchiverefstagsv0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d53c5bf2952a54cb8f9c3e3ad8a12c2acf0b92a834efab977afeb377805bcf21"
    sha256 cellar: :any,                 arm64_sonoma:  "77db12bb0dce57e6a8cfa7928395fe730871f1480a010a5b40711d2fcc18fb0c"
    sha256 cellar: :any,                 arm64_ventura: "6cbb8f306cfbf92da10622d2807745aa5f032302b7c273884cc024b08cc9e08c"
    sha256 cellar: :any,                 sonoma:        "1113006db39e5cfa332d2613b89259b130cc78e12152273b849c55e61fd14a83"
    sha256 cellar: :any,                 ventura:       "ecbf26df457bd43d76da7b8ea090fc99c915237937c72f42ea035e6d6e80ac1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb49ad009680d82bd21f793c61f5e6984feea004d165193c7b6d6107d5ba8c7"
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