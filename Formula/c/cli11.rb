class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https://cliutils.github.io/CLI11/book/"
  url "https://ghfast.top/https://github.com/CLIUtils/CLI11/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "c02abe5c5fed9b9c9192bff3c74d2c0d19755253f9ca9e3c44484c1cf5ce6568"
  license "BSD-3-Clause"
  head "https://github.com/CLIUtils/CLI11.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2822aa03da84d7aec73526ddbda7cda88de5dc1b8076c6b999dcf707231a52ce"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCLI11_BUILD_DOCS=OFF
      -DCLI11_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "CLI/App.hpp"
      #include "CLI/Formatter.hpp"
      #include "CLI/Config.hpp"

      int main(int argc, char** argv) {
          CLI::App app{"App description"};

          std::string filename = "default";
          app.add_option("-r,--result", filename, "A test string");

          CLI11_PARSE(app, argc, argv);
          std::cout << filename << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo\n", shell_output("./test -r foo")
  end
end