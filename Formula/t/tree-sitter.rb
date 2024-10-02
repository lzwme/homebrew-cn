class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.23.2.tar.gz"
  sha256 "ad81a585e399093bcba2fab179bf8971fdebaf701758af20d84d21f24fdf1b50"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9da2fa57f0c73ea494355d7a52f7ef7d3f8444aba8b4ae61e12b416a1eb9a0b"
    sha256 cellar: :any,                 arm64_sonoma:  "0f49dea31a86dfb5980ca4e37fcf2e2d882c9a9764929f158be695428d721628"
    sha256 cellar: :any,                 arm64_ventura: "acc9782da86f99e4d63e1221fd607697ef7bad0c2496333848255ebec40761c6"
    sha256 cellar: :any,                 sonoma:        "db9aa777f191470076974ec5263692995de9a9b125612e30e9f61238f5f5e904"
    sha256 cellar: :any,                 ventura:       "7717d5834c25f228d5769b914aa47ee42e98cb82a1fa0cb510d8bb117b826442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ede1fcbca769ac6422debbd49fb41ee0af98bfad66153cb58bcd5a10e398ce"
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