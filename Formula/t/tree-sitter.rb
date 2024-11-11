class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.24.4.tar.gz"
  sha256 "d704832a6bfaac8b3cbca3b5d773cad613183ba8c04166638af2c6e5dfb9e2d2"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d119ce2269c5307a15ad3851ba7ab850798cf52e9612e540ae0ee4423ad5081"
    sha256 cellar: :any,                 arm64_sonoma:  "d145dffd1b84c316932ceed7d77082212c065fccecd71edd2536627ca9b78943"
    sha256 cellar: :any,                 arm64_ventura: "72803f2363ef99d54bdbea0461c493c4c46a291c196cffe31213d0df66349475"
    sha256 cellar: :any,                 sonoma:        "d5ab3d9b04cb66d0e3526dddca3ae63732f9891fed6b17de485ab2b3f37851a0"
    sha256 cellar: :any,                 ventura:       "248646d8c6c6053bd944ed7e9c77347573bb31ec6c607a9e45aff44f6ec6ccf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e20ad3edd0fedd9c12222db569ae29bfc79aa23dde01bda5ef50b4b5fdf311e7"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
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
    system bin"tree-sitter", "test"

    (testpath"test_program.c").write <<~C
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
    C
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output(".test_program")
  end
end