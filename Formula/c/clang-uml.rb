class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https:github.combkryzaclang-uml"
  url "https:github.combkryzaclang-umlarchiverefstags0.5.3.tar.gz"
  sha256 "e830363ec510f14cc738c6509107b3f52bc55ececc2e27c068cadb093604e943"
  license "Apache-2.0"
  head "https:github.combkryzaclang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36d0aa1fa346deb13d765fb462e630b22b99c682e499456f7a00422feb96788a"
    sha256 cellar: :any,                 arm64_ventura:  "38d9e81d54fa5d33b7d45f33b10b8179497d77fe8b028e84ef58bdac808e2ccd"
    sha256 cellar: :any,                 arm64_monterey: "d1de2315c0e6bf8fab645a6a9f5fb2a07909987054d0fa06ecee7a41c00892cd"
    sha256 cellar: :any,                 sonoma:         "894596aee232128d1065aee22091c7757161de84763c8ec278f61d8ac1ce0433"
    sha256 cellar: :any,                 ventura:        "c9718ceba293590886e83858d3272621182900a51336d0777b1c9be613564019"
    sha256 cellar: :any,                 monterey:       "ab9b40e24efb743cb1ae94c6d71a39c2729735de62674dff332e094823ff2c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595c11370d9eaf6d557974d8b21c5398bc956e765cd0af9ce9233c116e2da6a5"
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

    if OS.mac? && (MacOS.version >= :ventura)
      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}c++"
      args << "-DCMAKE_INSTALL_RPATH=#{rpath(target: llvm.opt_lib)}"
    end

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