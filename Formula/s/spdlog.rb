class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https:github.comgabimespdlog"
  url "https:github.comgabimespdlogarchiverefstagsv1.15.0.tar.gz"
  sha256 "9962648c9b4f1a7bbc76fd8d9172555bad1871fdb14ff4f842ef87949682caa5"
  license "MIT"
  head "https:github.comgabimespdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "246130deacdb3cde7faa8e5159c6f03b2175160db08060a6d76ad36500e27175"
    sha256 cellar: :any,                 arm64_sonoma:  "d1e17b29906ba9ee8fbc5ec3ae90ed4c2cc1b5a28b7d1837a3f106435f77fdef"
    sha256 cellar: :any,                 arm64_ventura: "d594a2118a23b1817edccbc8b1c05930fd8cc31724b989086ccac6a5f5abc2cd"
    sha256 cellar: :any,                 sonoma:        "9f1b0e5bd8b2c7fe94cb7f5a71bb97cc14fcff4e98db8606b78638dd01181d91"
    sha256 cellar: :any,                 ventura:       "c4db7a7c3af2edc21bcc955663cc4bbe63969bcb1ac74996c3de1c4474b7c01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60250a68987a49d8aa950e3bdedfaaa2e19b3834813c01e2133c63b6d0f29bee"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  def install
    ENV.cxx11

    inreplace "includespdlogtweakme.h", " #define SPDLOG_FMT_EXTERNAL", <<~EOS
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    EOS

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
    lib.install "buildlibspdlog.a"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include "spdlogsinksbasic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}basic-log.txt");
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
    system ".test"
    assert_predicate testpath"basic-log.txt", :exist?
    assert_match "Test", (testpath"basic-log.txt").read
  end
end