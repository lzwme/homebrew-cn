class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://ghproxy.com/https://github.com/gabime/spdlog/archive/v1.11.0.tar.gz"
  sha256 "ca5cae8d6cac15dae0ec63b21d6ad3530070650f68076f3a4a862ca293a858bb"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "16013d6a43e020f01bdd793766168336582d42b119903b439d52fd438c72c547"
    sha256 cellar: :any,                 arm64_monterey: "c72bc8eb74c6f5a059b3295a6586265fbf1d585a208feb605f429ee6da9e85b4"
    sha256 cellar: :any,                 arm64_big_sur:  "279b8d7b3fc7f5214ae735af63edff89e2ea9dcb7c0a283adf6ea5ed2657214b"
    sha256 cellar: :any,                 ventura:        "a3bf0245297dbc22558243121d5d877c6eade70e0b5377f44659f4fd65455cc8"
    sha256 cellar: :any,                 monterey:       "eddf241209f659ddff4aad52a36193481c274e31fdcd60f84a17cb2f8416783b"
    sha256 cellar: :any,                 big_sur:        "abbbd02bf28f8c051009e1b82e5601823a6e895ed78e4d0e832c81f16ec657dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b7b637532bea31af1c54cca54effcc24bdd96dadef5843df2b12f17fce87d7"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  # error: specialization of 'template<class T, ...> struct fmt::v8::formatter' in different namespace
  fails_with gcc: "5"

  # Add support for fmt 10.0.0
  patch do
    url "https://github.com/gabime/spdlog/commit/0ca574ae168820da0268b3ec7607ca7b33024d05.patch?full_index=1"
    sha256 "31b22a9bfa6790fdabff186c0a9b0fd588439485f05cbef5e661231d15fec49b"
  end

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", <<~EOS
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    EOS

    args = std_cmake_args + %W[
      -Dpkg_config_libdir=#{lib}
      -DSPDLOG_BUILD_BENCH=OFF
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{Formula["fmt"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end