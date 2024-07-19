class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https:github.comgooglebenchmark"
  url "https:github.comgooglebenchmarkarchiverefstagsv1.8.5.tar.gz"
  sha256 "d26789a2b46d8808a48a4556ee58ccc7c497fcd4c0af9b90197674a81e04798a"
  license "Apache-2.0"
  head "https:github.comgooglebenchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b8107188b5464fd82a0eb6bef619216dca1c1acb4c54807853b7ca7c0a7bb68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d35ed300e5f4d576f0307f5436b98964f39e20b45610fb47cd3b28200eb525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7beaeaf5f83176400116468f2426fb4daeeac7b5d91f928301033d3318eaa5f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e20793bce48954150e078d4bdc5fcb8b8055dc42f36a7b18dbc6dee66863f50"
    sha256 cellar: :any_skip_relocation, ventura:        "2585e20f79fb5b75a3b7655e39c044818d1b2ec3b04ce308a184a00f3dba87aa"
    sha256 cellar: :any_skip_relocation, monterey:       "f61171cc5cf5724e70bda8293bc740f13811dd3c473eea7618bdb8dbde55536c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1535fa8185d11b074b42adf0f314a73cedf4e777c4c8e0f52f16352784554f9b"
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
    (testpath"test.cpp").write <<~EOS
      #include <string>
      #include <benchmarkbenchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    EOS
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system ".test"
  end
end