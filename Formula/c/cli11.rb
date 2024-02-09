class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https:cliutils.github.ioCLI11book"
  url "https:github.comCLIUtilsCLI11archiverefstagsv2.4.1.tar.gz"
  sha256 "73b7ec52261ce8fe980a29df6b4ceb66243bb0b779451dbd3d014cfec9fdbb58"
  license "BSD-3-Clause"
  head "https:github.comCLIUtilsCLI11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc2b6dd32f38c71c9b8f099d47dda0dad6c3c7c7f42159387bfda44282743b67"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCLI11_BUILD_DOCS=OFF", "-DCLI11_BUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "CLIApp.hpp"
      #include "CLIFormatter.hpp"
      #include "CLIConfig.hpp"

      int main(int argc, char** argv) {
          CLI::App app{"App description"};

          std::string filename = "default";
          app.add_option("-r,--result", filename, "A test string");

          CLI11_PARSE(app, argc, argv);
          std::cout << filename << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo\n", shell_output(".test -r foo")
  end
end