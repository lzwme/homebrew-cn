class Md4c < Formula
  desc "C Markdown parser. Fast. SAX-like interface"
  homepage "https:github.commitymd4c"
  url "https:github.commitymd4carchiverefstagsrelease-0.5.1.tar.gz"
  sha256 "2dca17c6175a7f11182943079c2a4f9adb5071433e3d3d05ba801ff794993f34"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32dcf01cd5de8cef22747e7295db6e7a274d68063ae416cf9c3a56af696bb0e6"
    sha256 cellar: :any,                 arm64_ventura:  "195b234c21b23c92912a1fcd42a5603e6357fc4cbcd0c32e292bad8045eab5cb"
    sha256 cellar: :any,                 arm64_monterey: "a7eddff218c17adf1d46cc0a5678104cfec0a013aa45487ba56eb8c88ccbdde9"
    sha256 cellar: :any,                 sonoma:         "c28496cda30281d2de8d162be41d8a660602d0e6aa01355a2fd7b2e68cb03974"
    sha256 cellar: :any,                 ventura:        "d497dfc84c299e521cd05e18b6245bc1610b079578202ad7fbd28a1223472338"
    sha256 cellar: :any,                 monterey:       "6cac15c44d8e6c5abca1149fe211a9d0ec541bbfa19530b7c741f16760464798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcdc9b09011de141187ce914e6ddd2675556e2086b254bef8714b164540502be"
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