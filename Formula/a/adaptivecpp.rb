class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://ghfast.top/https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.02.0.tar.gz"
  sha256 "8cc8a3be7bb38f88d7fd51597e0ec924b124d4233f64da62a31b9945b55612ca"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "b64dea8eba9f43b61be66118c129a95282af9774ff01ccb26462ca27c02ee2b4"
    sha256 arm64_sequoia: "f8d303163cea44ae411f9e87ab47ee27d55c606947d53400ddb98bc0a5ded3d5"
    sha256 arm64_sonoma:  "b3b96b81ff893ff2c13ee51aaae39b641578fb7396de843c45800eb06524de89"
    sha256 sonoma:        "37f755b817e733580418205802ca9ee25b29714b02cd166cc6ac73360752ebbc"
    sha256 arm64_linux:   "67ead23c19a08e8e48ab36fe97a5e602eb2508998bc4c93d098a3f369161a93a"
    sha256 x86_64_linux:  "0007c52823b9d6ad8e2c13fe8a3d47f8d89b2230b4b6d626ab2c3718af24db64"
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
      ["-DACPP_EXPERIMENTAL_LLVM=ON"]
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
  end
end