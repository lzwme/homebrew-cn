require "languagenode"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.20.8.tar.gz"
  sha256 "6181ede0b7470bfca37e293e7d5dc1d16469b9485d13f13a605baec4a8b1f791"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b07074890f8a9620df7fb0c252f5d213af4ef5b58222fe5cde17400c99e25b66"
    sha256 cellar: :any,                 arm64_ventura:  "6e4708d36f22c77e6684ded811a78a1922e6c2bef68f63cdf5804fd224ead544"
    sha256 cellar: :any,                 arm64_monterey: "fe5a46ba39768f48b6563774da3a7a5b32f42d589f55c2fc44cfe1e16428e3ef"
    sha256 cellar: :any,                 sonoma:         "e3466ba768c5e8e4f4678c144ac95c72f142b05e13cd9c8175b3a4e2dac5d257"
    sha256 cellar: :any,                 ventura:        "c557635510c62acf4ad1a12e10ceb309f2988fd988723d0fa3711841263823e7"
    sha256 cellar: :any,                 monterey:       "e0b89995ed669a6ffae020bf2c1501b48604e632981ef455dedcc09f7cb4a252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa74e3b160bd5578648205a8744bfd3f9c926d044b15041c4ffe0cc995e39dc"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "AMALGAMATED=1"
    system "make", "install", "PREFIX=#{prefix}"
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath"grammar.js").write <<~EOS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    EOS
    system bin"tree-sitter", "generate", "--abi=latest"

    # test `tree-sitter parse`
    (testpath"testcorpushello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}tree-sitter parse #{testpath}testcorpushello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath"test""corpus""test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system "#{bin}tree-sitter", "test"

    (testpath"test_program.c").write <<~EOS
      #include <string.h>
      #include <tree_sitterapi.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
         Because we have no language libraries installed, we cannot
         actually parse a string successfully. But, we can verify
         that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output(".test_program")
  end
end