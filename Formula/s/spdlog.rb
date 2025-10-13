class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://ghfast.top/https://github.com/gabime/spdlog/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "8741753e488a78dd0d0024c980e1fb5b5c85888447e309d9cb9d949bdb52aa3e"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e551c179dac2be2cabfa187f2d44719f4759a812964fde8bedae14b1eb8ef6c9"
    sha256 cellar: :any,                 arm64_sequoia: "de5daee568dd987d111c7bf013963e9d126a43d122c2a7394490c538de56604a"
    sha256 cellar: :any,                 arm64_sonoma:  "fcb20fdb222418cd7e7bdc6aaa81774367f6fb2f701db93ad2e85c9517831f72"
    sha256 cellar: :any,                 sonoma:        "a77eeef870d22f0dc2efff1f30500614b9a0d85ca60b235d74734ef26011f5d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aba3b9998c01e14c5ba0d4cb313feed4d28f41dc07b730b15123d38287ec9bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4476b2b3ebe72b98a0b1386a0a5f8c44ca96facb5b5b257f3c17b3d5503f11d"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", <<~C
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    C

    args = std_cmake_args + %W[
      -Dpkg_config_libdir=#{lib}
      -DSPDLOG_BUILD_BENCH=OFF
      -DSPDLOG_BUILD_EXAMPLE=OFF
      -DSPDLOG_BUILD_TESTS=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]
    system "cmake", "-S", ".", "-B", "build", "-DSPDLOG_BUILD_SHARED=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", "-DSPDLOG_BUILD_SHARED=OFF", *args
    system "cmake", "--build", "build"
    lib.install "build/libspdlog.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "spdlog/sinks/basic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}/basic-log.txt");
          console->info("Test");
        }
        catch (const spdlog::spdlog_ex &ex)
        {
          std::cout << "Log init failed: " << ex.what() << std::endl;
          return 1;
        }
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{Formula["fmt"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_path_exists testpath/"basic-log.txt"
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end