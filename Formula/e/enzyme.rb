class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  # upstream issue report, https://github.com/EnzymeAD/Enzyme/issues/1480
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.89.tar.gz", using: :homebrew_curl
  sha256 "1b8c356cc03c12217e0526559fbbc754dae1870fe626bc8ab86ed2c1ebb76f68"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14c0ac25fa2a95cf7eb99853a8952fdac018cecf4099f99dd0cca08983934af8"
    sha256 cellar: :any,                 arm64_ventura:  "03628dbe9e7d878fea0aad7a58c5667af55f1892ad7949874cb3a820222fc83d"
    sha256 cellar: :any,                 arm64_monterey: "18de736a0cb4671f9a7c9dec4ec4f4eab27bbaa547e0185583ef8eef3c43be3e"
    sha256 cellar: :any,                 sonoma:         "45c5b81175908513cbae54e40ec5eae9f306373450e024178b9c56f3a0f36610"
    sha256 cellar: :any,                 ventura:        "584ee3dd66fc97b9b99c8925292deee36c01cf40b7dbc0621faa8c93e5edbb4d"
    sha256 cellar: :any,                 monterey:       "c744745c2462291a374c910ffa40e48a1ce9aac1c78b26a5881e4dafc934a0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85cdcc7912f0d4ace07b549f71b1f352b63588c0685102e3293f9ba58fe52137"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end