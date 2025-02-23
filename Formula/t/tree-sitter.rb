class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.25.2.tar.gz"
  sha256 "26791f69182192fef179cd58501c3226011158823557a86fe42682cb4a138523"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4207c6a66590dcdff74255b2f2f707a7018d4c96dbb46f92251dfad5113c0b2c"
    sha256 cellar: :any,                 arm64_sonoma:  "ecfaacb21adc467d7a27376f31c6298017d946f84f43533fd74fbbb0dfb1529f"
    sha256 cellar: :any,                 arm64_ventura: "f50918f092a7f13358a98a2720fad3f75b250f772b9d07e168382a1ec617d9c7"
    sha256 cellar: :any,                 sonoma:        "ecf0002bd8a2df4db86b0c6cb2026795147fb5aeae853aa4f2ff3334e72e392e"
    sha256 cellar: :any,                 ventura:       "15e6de4ff5e6e04e8befb0d38d5260a3d905fc4fb0b2c1015ea1a76e8fdcf732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180861f05fc8c73e4e2e5bbdeeb643d31543052d5fbb5babd850ae665a0c9ec7"
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
    (testpath"grammar.js").write <<~JS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    JS
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