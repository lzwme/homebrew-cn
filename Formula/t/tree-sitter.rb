class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https:github.comtree-sittertree-sitterarchiverefstagsv0.24.1.tar.gz"
    sha256 "7adb5bb3b3c2c4f4fdc980a9a13df8fbf3526a82b5c37dd9cf2ed29de56a4683"

    # Fix `.pc` file generation. Remove at next release.
    # https:github.comtree-sittertree-sitterpull3745
    patch do
      url "https:github.comtree-sittertree-sittercommit079c69313fa14b9263739b494a47efacc1c91cdc.patch?full_index=1"
      sha256 "d2536bd31912bf81b2593e768159a31fb199fe922dafb22b66d7dfba0624cc25"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c38fb31907c808f4ea3b888a416147f143b9dd34e3247f168be845f9b13102ed"
    sha256 cellar: :any,                 arm64_sonoma:  "8ebe5cdfc4d228e41e722d4a806bc727bb2dd3d00d7c86f12ef9939796d41bfc"
    sha256 cellar: :any,                 arm64_ventura: "b700c06d13eddfaf83edf4dfed45ccb7a096ef85c3bc05ecd0ac4fd69b6aa8d0"
    sha256 cellar: :any,                 sonoma:        "503f7eceee26d8bd10fda3bdf62bfcd30cbfba7a7f385c01296542be79b87237"
    sha256 cellar: :any,                 ventura:       "462f3c6ecd458e75e4a3ae22d71f2e85ce7c1debf09b735ef9adf294e6227555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03906c550859cbc081475a4f8ee38321abb7899223f8ad8fb85efbe12d4f25b3"
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