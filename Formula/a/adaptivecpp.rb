class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://ghfast.top/https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.02.0.tar.gz"
  sha256 "8cc8a3be7bb38f88d7fd51597e0ec924b124d4233f64da62a31b9945b55612ca"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "c7d4959352b8ebddf43641929597f0ba52212c921c1f3933980f32fa06d925fe"
    sha256 arm64_sequoia: "8d7276450c277fe9378aa8bb2c959adbec2ea0a4072ec9416cb3cb43263b6950"
    sha256 arm64_sonoma:  "a7d8243f1f5151c7a3b2875f9fba1412755663d5b085c87e9ec3b6a005f9cb35"
    sha256 sonoma:        "0e5825f933f4d87ec3d66a25c4d7a931cd5be6aaf7d0dd5e2d62cfdcca9e8396"
    sha256 arm64_linux:   "1442b54a1ed1362ef94e93e073c8090df229b495195131e5e66467cc6b1be3eb"
    sha256 x86_64_linux:  "ba6fea3e06fe2291cad07ec926c56cc1335b29401ca984a01be13484689def1e"
  end

  depends_on "cmake" => :build
  depends_on "boost" # needed to use collective_execution_engine.hpp

  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "llvm"

    # Backport support for LLVM 21
    patch do
      url "https://github.com/AdaptiveCpp/AdaptiveCpp/commit/623aa0b1840c5ccd7a45d3e8b228f1bff5257056.patch?full_index=1"
      sha256 "d3b8708ded954f04b87ad22254fd949c1d584d6de7a3f8a7e978ff715ca1a33d"
    end
  end

  def install
    args = if OS.mac?
      libomp_root = Formula["libomp"].opt_prefix
      ["-DOpenMP_ROOT=#{libomp_root}"]
    else
      %W[
        -DACPP_EXPERIMENTAL_LLVM=ON
        -DCLANG_EXECUTABLE_PATH=#{Formula["llvm"].opt_bin/"clang++"}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace prefix/"etc/AdaptiveCpp/acpp-core.json", Superenv.shims_path/ENV.cxx, ENV.cxx

    if OS.mac?
      # we add -I#{libomp_root}/include to default-omp-cxx-flags
      inreplace prefix/"etc/AdaptiveCpp/acpp-core.json",
                "\"default-omp-cxx-flags\" : \"",
                "\"default-omp-cxx-flags\" : \"-I#{libomp_root}/include "
    else
      # Move tools to work around brew's non-executable audit
      (lib/"hipSYCL/llvm-to-backend").install (bin/"hipSYCL/llvm-to-backend").children
    end
  end

  test do
    system bin/"acpp", "--version"

    (testpath/"hellosycl.cpp").write <<~C
      #include <sycl/sycl.hpp>
      int main() {
          sycl::queue q{};
      }
    C
    system bin/"acpp", "hellosycl.cpp", "-o", "hello"
    system "./hello"

    unless OS.mac?
      refute_match Formula["llvm"].prefix.realpath.to_s,
                   (etc/"AdaptiveCpp/acpp-core.json").read,
                   "`acpp-core.json` references `llvm`'s cellar path"
    end
  end
end