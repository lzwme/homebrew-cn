class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://ghproxy.com/https://github.com/google/benchmark/archive/v1.8.1.tar.gz"
  sha256 "e9ff65cecfed4f60c893a1e8a1ba94221fad3b27075f2f80f47eb424b0f8c9bd"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0e89baa2e252957b750a59021b7b95bfb95688e825ae71b9f06136dba4451b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d928b7f7cb0d5b9429a8a646b57d9f2d970cb5f0f69edd8b6da1111bd3b5898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c79ab5d7537607259f76f1cbc223db4700d6b74c82edc348013c6ee54eca2a2"
    sha256 cellar: :any_skip_relocation, ventura:        "bd07e84b1c10b7b20cc22cb7d303ea8c120be0a6c15ac44036e68ab2c4127fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "1aaa69ced6c06676645c1c384de3bd21526ea59f76b1b30ee355a3dc2711fd07"
    sha256 cellar: :any_skip_relocation, big_sur:        "36fec87dc82d16cfe05d8491fb33e4bb8b1ec3e3e4472f13370112b7a686fd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b87fa7b5f8eb3ac1f388669c6bbaf268c2f8e759b3d0d33bce23f0d03d2ed4"
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
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <benchmark/benchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    EOS
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end