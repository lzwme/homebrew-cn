class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https:github.combkryzaclang-uml"
  url "https:github.combkryzaclang-umlarchiverefstags0.5.3.tar.gz"
  sha256 "e830363ec510f14cc738c6509107b3f52bc55ececc2e27c068cadb093604e943"
  license "Apache-2.0"
  head "https:github.combkryzaclang-uml.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ae11b22d67d7ea38967de689b7257574138dfae301cfb3aef21358bce38f4044"
    sha256 cellar: :any,                 arm64_ventura:  "711a1c13d68ef7b5e8853ffa5732566df3e62d88759a2dcbd61b60a136bb068f"
    sha256 cellar: :any,                 arm64_monterey: "f7bf5af198bbe107ab545e16d79bbb280363db0addd85409e21065757e03918b"
    sha256 cellar: :any,                 sonoma:         "8ef84c0c0ff33aa76f7a777776d17cf13eb8e3ba7af2bc2ef323468e2634dbf0"
    sha256 cellar: :any,                 ventura:        "dabc45f366e1d0d8d8b0cec7475fea52e2f0422844c3547065033b34b0007616"
    sha256 cellar: :any,                 monterey:       "da1344a9733f0bf84eef780601019bd45e0799adf5713e097441cf72823306cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75868a2b3fd4e753c13bbf417b318356915f75072d6f8f6097512bef0de1a4c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "yaml-cpp"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula)
        .find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
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