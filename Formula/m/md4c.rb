class Md4c < Formula
  desc "C Markdown parser. Fast. SAX-like interface"
  homepage "https:github.commitymd4c"
  url "https:github.commitymd4carchiverefstagsrelease-0.5.0.tar.gz"
  sha256 "79548a689bb931d099dc8242a6824e13160553fa843ae3d8a9eded571d89168e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8142cb4d9f56c31c57e021bb2b32688889110df24c5290291d50647f785b0c11"
    sha256 cellar: :any,                 arm64_ventura:  "fd54f77b56f74071a87345e26e0c3071914692761f4850fc4b6c96211e1a04c2"
    sha256 cellar: :any,                 arm64_monterey: "2859477205981a24441039d49583778885987f9b22f0155d9f8df872761b1163"
    sha256 cellar: :any,                 sonoma:         "dc465385d7887e97091f33c2e7e613ee0603d038c0420bfe8d71d7aae650e00f"
    sha256 cellar: :any,                 ventura:        "d2df8c08bf2d003bd0ec1dbb3b5ba9027101d357ba6c42a485ac904e31623f9a"
    sha256 cellar: :any,                 monterey:       "a8a62db3d4514cba8dd123dd4db39a823ac203cca944a5184c7d59e633e51a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ab09ac36513ddf6abcd97de88bd9b67a1efa2cfe031e73ce437abcce07806f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # test md2html
    (testpath"test_md.md").write <<~EOS
      # Title
      some text
    EOS
    system bin"md2html", ".test_md.md"

    # test libmd4c
    (testpath"test_program.c").write <<~EOS
      #include <stddef.h>
      #include <md4c.h>

      MD_CHAR* text = "# Title\\nsome text";

      int test_block(MD_BLOCKTYPE type, void* detail, void* data) { return 0; }
      int test_span(MD_SPANTYPE type, void* detail, void* data) { return 0; }
      int test_text(MD_TEXTTYPE type, const MD_CHAR* text, MD_SIZE size, void* userdata) { return 0; }
      int main() {
        MD_PARSER parser = {
          .enter_block = test_block,
          .leave_block = test_block,
          .enter_span = test_span,
          .leave_span = test_span,
          .text = test_text
        };
        int result = md_parse(text, sizeof(text), &parser, NULL);
        return result;
      }
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-lmd4c", "-o", "test_program"
    system ".test_program"
  end
end