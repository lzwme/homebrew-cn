class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://ghfast.top/https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.02.0.tar.gz"
  sha256 "8cc8a3be7bb38f88d7fd51597e0ec924b124d4233f64da62a31b9945b55612ca"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "37dd9cca4796ceef606befa403a354a6a19c4a87bbd7e3a2d0ce767539fc26bf"
    sha256 arm64_sequoia: "b15d036cae2e39d5c4dabd86d8606d85aba8b777c93849ed01c7b69d95909777"
    sha256 arm64_sonoma:  "17557ca2e27aacabcf97669602904b6e13ad9d19b715c9463e5d8216608279d0"
    sha256 sonoma:        "bd71eb34aea708ced4cc1dd577ab816dbe00f2c6341022f369169e62074c71e7"
    sha256 arm64_linux:   "68e47436f48595911a2fa1c08ca162c83f42ca60b69e64d5cd64d2d08e24d214"
    sha256 x86_64_linux:  "5792881d3fa418198526fbbb381cead68d0eb343ce17095d5a90661e2e231123"
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