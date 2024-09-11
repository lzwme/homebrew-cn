class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.23.0.tar.gz"
  sha256 "6403b361b0014999e96f61b9c84d6950d42f0c7d6e806be79382e0232e48a11b"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4d51492f80898622c26be8d01d288c0070eaaf9958a60d2a642539d89d1501ca"
    sha256 cellar: :any,                 arm64_sonoma:   "841e33489720a0e054818f83d9f030eaa4aba900e15c390f99c92a4b55f76a6f"
    sha256 cellar: :any,                 arm64_ventura:  "91064f7ea239da4f4b945c5f5049803caf5f9ccc892ad12617071c5feb9858bf"
    sha256 cellar: :any,                 arm64_monterey: "d6636df7e42af07eeaada4eebe83bf74407b861fb0c329cfa425ba107789959a"
    sha256 cellar: :any,                 sonoma:         "c3b96caa7b63f64611036be597291823c1b1b0bf52c368d8bfadec2963377fe1"
    sha256 cellar: :any,                 ventura:        "910354d5a86b360bba71c05dccf7cb99c63ce5cbba1133d5eb146c99c1ceb0e2"
    sha256 cellar: :any,                 monterey:       "2f6b9e63778e0d20d6586123853cc76c64460980bb31c59bc4a2ed840123de85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f71caad1b9627a77924e14b804fc93be99a164164c8023df107cc63f70f188f"
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