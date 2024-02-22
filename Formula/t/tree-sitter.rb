require "languagenode"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.21.0.tar.gz"
  sha256 "6bb60e5b63c1dc18aba57a9e7b3ea775b4f9ceec44cc35dac4634d26db4eb69c"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10b7beaad80c6ca3410b0aa4dfa0499a6a095869075d147e4eb320aea363abde"
    sha256 cellar: :any,                 arm64_ventura:  "c7ef2da9543dcae0b90d82988c13c3bf9e8afef93f5adce6a273605f1dc76f3f"
    sha256 cellar: :any,                 arm64_monterey: "8ec311b3df303d116fe1eb27f8a251194c255ed0e8a2914f9e99cc19860fd4d5"
    sha256 cellar: :any,                 sonoma:         "8155f106a960a9b3f01094067ef1945cea5f87995840fffe0f7a00334be74d70"
    sha256 cellar: :any,                 ventura:        "f2eaf9b86487e2287980824748dc2be1cd996e2801796a337c0a90c7293c238f"
    sha256 cellar: :any,                 monterey:       "f8df67737262e44f2c79fb03e4be35b0ca1d47115f60739b1a4879907ae9a5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "964da70e6d1f49a84bdf167f2c5cce51f4973593a1fc2a78898bb09f7ad3b625"
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
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result.split("\n")[-1])

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