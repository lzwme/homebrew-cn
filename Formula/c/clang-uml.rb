class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https:github.combkryzaclang-uml"
  url "https:github.combkryzaclang-umlarchiverefstags0.5.4.tar.gz"
  sha256 "445ae69e9ef7dcc50d0352dcd79d8c55994a7bebd84684f95405fd81168338c4"
  license "Apache-2.0"
  revision 1
  head "https:github.combkryzaclang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9927bed78f589e47e24c8eacf0fcb3e136982dfe4f3120b2cc18435dce43ac8a"
    sha256 cellar: :any,                 arm64_sonoma:  "93dca4721249fe73a856e83c43042b92341552a8904995b508a0c68c28cf554c"
    sha256 cellar: :any,                 arm64_ventura: "98c57248f12fda4f74a6a0ed0bba7312a89f4e96c5946050a9d1bf221611c73a"
    sha256 cellar: :any,                 sonoma:        "a544e1ed6d5dc78353b4997ee5ec34704ebeae01d8d5fcdca372a9439a61f2ec"
    sha256 cellar: :any,                 ventura:       "0b8240b547f5a67695d217c0ebba55ba9b19fa2806aa9e817e19ec396c95522c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0cb3bc5af05f8471c9ef49a18a9e16a0c05de75343ae90f4ea46ac6207a33e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "llvm@18"
  depends_on "yaml-cpp"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula)
        .find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    args = %w[
      -DBUILD_TESTS=OFF
    ]

    # If '.git' directory is not available during build, we need
    # to provide the version using a CMake option
    args << "-DGIT_VERSION=#{version}" if build.stable?

    # Use LLVM-provided libc++
    args << "-DCMAKE_EXE_LINKER_FLAGS=-L#{llvm.opt_lib}c++ -L#{llvm.opt_lib} -lunwind" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "packagingautocompleteclang-uml"
    zsh_completion.install "packagingautocomplete_clang-uml"
  end

  def caveats
    on_macos do
      <<~EOS
        If you see errors such as `fatal: 'stddef.h' file not found`, try
        adding `--query-driver .` to the `clang-uml` command line in order to
        ensure that proper system headers are available to Clang.

        For more information see: https:clang-uml.github.iomd_docs_2troubleshooting.html
      EOS
    end
  end

  test do
    # Check if clang-uml is linked properly
    system bin"clang-uml", "--version"
    system bin"clang-uml", "--help"

    # Initialize a minimal C++ CMake project and try to generate a
    # PlantUML diagram from it
    (testpath"test.cc").write <<~EOS
      #include <stddef.h>
      namespace A {
        struct AA { size_t s; };
      }
      int main(int argc, char** argv) { A::AA a; return 0; }
    EOS
    (testpath".clang-uml").write <<~EOS
      compilation_database_dir: build
      output_directory: diagrams
      diagrams:
        test_class:
          type: class
          include:
            namespaces:
              - A
    EOS
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.15)

      project(clang-uml-test CXX)

      set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

      add_executable(clang-uml-test test.cc)
    EOS

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args

    system bin"clang-uml", "--no-metadata", "--query-driver", "."

    expected_output = Regexp.new(<<~EOS, Regexp::MULTILINE)
      @startuml
      class "A::AA" as C_\\d+
      class C_\\d+ {
      __
      \\+s : size_t
      }
      @enduml
    EOS

    assert_predicate testpath"diagrams""test_class.puml", :exist?

    assert_match expected_output, (testpath"diagramstest_class.puml").read
  end
end