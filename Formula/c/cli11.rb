class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https:cliutils.github.ioCLI11book"
  url "https:github.comCLIUtilsCLI11archiverefstagsv2.4.0.tar.gz"
  sha256 "d2ce8d5318d2a7a7d1120e2a18caac49cd65423d5d4158cbbc0267e6768af522"
  license "BSD-3-Clause"
  head "https:github.comCLIUtilsCLI11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7688b1e80a07d15c514e081a1cf4d0d1c204668d32fd30556463d7fce5c9f1bf"
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