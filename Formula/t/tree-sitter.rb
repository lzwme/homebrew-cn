require "languagenode"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.20.9.tar.gz"
  sha256 "9b2fd489a7281e3a7e5e7cbbf3a974e5a6a115889ae65676d61b79bdae96464e"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "062befbe55cf56c8fad131a5c5c716e56c4dd6909b4f148cd6198840b1c00bbf"
    sha256 cellar: :any,                 arm64_ventura:  "6151a7f25d123ccce15e09cc5e72836f8ee07177ce63ad51fa98def7dd145e22"
    sha256 cellar: :any,                 arm64_monterey: "0237ac036dea1d1d64d0989777edf18f26a4a0fb3b259ec3ed7e0a6bf166fa60"
    sha256 cellar: :any,                 sonoma:         "1f41896166871dfe5197461081a057db4a51c667550fc676c956dd102761bfb3"
    sha256 cellar: :any,                 ventura:        "e98c3c0145cc48cea7b13f10c155e792e4bd135c814c8c093c6a5bf9c34288da"
    sha256 cellar: :any,                 monterey:       "94cd6bf2a1e61e3c5f17c45489b3a3b4a3646e373cf6f41f31e1706f7d0f25e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c98f13c1a6a350433fbf0536f099da86c4db828d2de6296a2445c754339c7ce"
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
      #include <stdio.h>
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