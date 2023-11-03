class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/symengine/symengine/releases/download/v0.11.1/symengine-0.11.1.tar.gz"
  sha256 "217b39955dc19f920c6f54c057fdc89e8e155ddee8f0e3c3cacc67b3e3850b64"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe11b29c50b5ac1d28bef924361dffeb2de8b09da2247ba123819ca2552a5760"
    sha256 cellar: :any,                 arm64_ventura:  "efc0ff53a082ca117aa7d0d819564cc9021ba84fac02d39588e01be1661c9170"
    sha256 cellar: :any,                 arm64_monterey: "e05322d032bdc1c0ae174674565285ada017a481a3cf81981e6e7c0b520fe179"
    sha256 cellar: :any,                 sonoma:         "24fe7172403cd00a3e32f819a6c7c3601a36c0c1b69e248e520cb7dc68d578a9"
    sha256 cellar: :any,                 ventura:        "3e9d869cb1d90555aca46f2cc1c5b20208ce6c3561f3eceb37e8bb3852316447"
    sha256 cellar: :any,                 monterey:       "efa17ff396750bea4f9ccfb9bb9a40e80f539209efc4b008897635f4ae2507e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c51c1ac6419fb5966a192f83f4d85ca01725e8044a7c16fb4df84b6322f70f"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm@16"
  depends_on "mpfr"

  fails_with gcc: "5"

  # Avoid static linkage with LLVM. The static libraries contain
  # LTOed objects which causes errors with Apple's `ld`.
  # An alternative workaround is to use `lld` with `-fuse-ld=lld`.
  # TODO(carlocab): Upstream a version of this patch.
  patch do
    url "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/symengine/files/symengine-0.8.1-fix_llvm.patch?id=83ab9587be9f89e667506b861208d613a2f016e5"
    sha256 "c654ea7c4ee44c689433e87f71c7ae78e6c04968e7dfe89be5e4ba4c8c53713b"
  end

  # fix flint 3 compatibility
  # https://github.com/symengine/symengine/pull/1985, remove in next release
  patch do
    url "https://github.com/symengine/symengine/commit/9b2526ffee85ebb2b3011513ae544aec1b54d623.patch?full_index=1"
    sha256 "8232c3cd757e8f9eecf296bc8e8353830c604d89e368b12de0c45715a7fa660d"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_GMP=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DWITH_COTIRE=OFF",
                    "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm",
                    "-DWITH_SYMENGINE_THREAD_SAFE=ON",
                    "-DWITH_SYSTEM_CEREAL=ON",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <symengine/expression.h>
      using SymEngine::Expression;
      int main() {
        auto x=Expression('x');
        auto ex = x+sqrt(Expression(2))+1;
        auto equality = eq(ex+1, expand(ex));
        return equality == true;
      }
    EOS
    lib_flags = [
      "-L#{Formula["gmp"].opt_lib}", "-lgmp",
      "-L#{Formula["mpfr"].opt_lib}", "-lmpfr",
      "-L#{Formula["flint"].opt_lib}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end