class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https:standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 16
  head "https:github.comstandardesestandardese.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https:github.comstandardesestandardese.git",
        tag:      "0.5.2",
        revision: "0b23537e235690e01ba7f8362a22d45125e7b675"

    # Fix build with new GCC.
    # https:github.comstandardesestandardesepull233
    patch do
      url "https:github.comstandardesestandardesecommit15e05be2301fe43d1e209b2f749c99a95c356e04.patch?full_index=1"
      sha256 "e5f03ea321572dd52b9241c2a01838dfe7e6df7e363a8d19bfeac5861baf5d3f"
    end
  end

  bottle do
    sha256                               arm64_sonoma:   "6166cdd409393c81b194cadd60222e3ea5b9e31b480428e5a38c2da7fd71bf3f"
    sha256                               arm64_ventura:  "3d60eee3619b6f879efd2255556c983f28f04d56c6e1a3507af8958829f2adbd"
    sha256                               arm64_monterey: "2a95f4e9a7968eeaf74614c2048f5dab0a61d25ae6048f1e36b42c208f96fe3e"
    sha256                               sonoma:         "1ed661bac7ee3f4baccc2593a99b1f5f93eb244d6e590cee905724b6e536dfba"
    sha256                               ventura:        "9da6db645e8be2b636dc6a5402c5e20d444443cb05740a8c3f28f2cbbe7495aa"
    sha256                               monterey:       "ec417af3efb5cb2c9273609b9e616b44c2b23a9bdc919f4933177c6ab0b27c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c91ec9ce61b49137b60c619d6dc4349912e572a54ce4a146a79886a3b13616"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    # Don't build shared libraries to avoid having to manually install and relocate
    # libstandardese, libtiny-process-library, and libcppast. These libraries belong
    # to no install targets and are not used elsewhere.
    # Disable building test objects because they use an outdated vendored version of catch2.
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMARK_LIBRARY=#{Formula["cmark-gfm"].opt_libshared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{Formula["cmark-gfm"].opt_include}",
                    "-DSTANDARDESE_BUILD_TEST=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install "includestandardese"
    (lib"cmakestandardese").install "standardese-config.cmake"
  end

  test do
    (testpath"test.hpp").write <<~EOS
      #pragma once

      #include <string>
      using namespace std;

       \\brief A namespace.
      
       Namespaces are cool!
      namespace test {
          ! A class.
           \\effects Lots!
          class Test {
          public:
              int foo; < Something to do with an index into [bar](<> "test::Test::bar").
              wstring bar; < A [wide string](<> "std::wstring").

               \\requires The parameter must be properly constructed.
              explicit Test(const Test &) noexcept;

              ~Test() noexcept;
          };

           \\notes Some stuff at the end.
          using Baz = Test;
      };
    EOS
    system bin"standardese", "--compilation.standard", "c++17",
                              "--output.format", "xml",
                              testpath"test.hpp"
    assert_includes (testpath"doc_test.xml").read, "<subdocument output-name=\"doc_test\" title=\"test.hpp\">"
  end
end