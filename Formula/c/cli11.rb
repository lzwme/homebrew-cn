class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https://cliutils.github.io/CLI11/book/"
  url "https://ghfast.top/https://github.com/CLIUtils/CLI11/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "8c11bc049090a66cb71c3e90350cddaa792b2a45e0a7841799900b95ca38b101"
  license "BSD-3-Clause"
  head "https://github.com/CLIUtils/CLI11.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6278eaca8818fbf5d1496d7bdd4e3f5de5dabad97bf3b77d1880eee4647111d4"
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