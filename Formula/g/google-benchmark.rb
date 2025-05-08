class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https:github.comgooglebenchmark"
  url "https:github.comgooglebenchmarkarchiverefstagsv1.9.3.tar.gz"
  sha256 "b94263b018042007eb53f79639f21ae47800808c73cf1b7df85622b6e2b1aa32"
  license "Apache-2.0"
  head "https:github.comgooglebenchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff542a84b0848317c9b65b1d20130020121308bda6cd41202e86356291b820bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffba486b66a5737a29abc608c486ae2b15561a4acba433fcaf717c989a77f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59930fd740d86d7ba15a534a1035d527a41b7d0e9bd9b249b40877fb3b68566a"
    sha256 cellar: :any_skip_relocation, sonoma:        "93ee322a5f13476c138f6ab6e70c4df064849905cd41a2c486613841a24df102"
    sha256 cellar: :any_skip_relocation, ventura:       "31a0c35b6da97d71ff673f1823be2fc7525c6e8da7ee776b08bfa1fa033cd7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9413e089d5f100191be01e0044e765c0ea1be673b1fe1600e34ec7f8495fca97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50ec9976014065b2e0472d34448349fa63580c84574edb85fd8fdceed312aa7"
  end

  depends_on "cmake" => :build

  def install
    args = %w[-DBENCHMARK_ENABLE_GTEST_TESTS=OFF]
    # Workaround for the build misdetecting our compiler features because of superenv.
    args << "-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <string>
      #include <benchmarkbenchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    CPP
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-std=c++17", "-o", "test", "test.cpp", *flags
    system ".test"
  end
end