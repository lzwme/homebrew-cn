class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.22.4.tar.gz"
  sha256 "919b750da9af1260cd989498bc84c63391b72ee2aa2ec20fc84882544eb7a229"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2940bb321a539d802c35640a7ae984f2d23565323aa0cdb3642cc5836fa1aa88"
    sha256 cellar: :any,                 arm64_ventura:  "42dca623e7b0c1ed2eeabc878dcb8f29445ab9a333f7dcf0a983e65e246718b8"
    sha256 cellar: :any,                 arm64_monterey: "696242c85e2f11a18cc6e6219e80d57567d09bea54d72d7baf0a72fee4987909"
    sha256 cellar: :any,                 sonoma:         "f0239ce39e88f29a2982ea2c3aedadc7404defbdaac7dc72be86c997c0edeb07"
    sha256 cellar: :any,                 ventura:        "8ea90c91a437225cca0df76f3f4193d717160aec84c286f5c88d5f1ebf925637"
    sha256 cellar: :any,                 monterey:       "76a633919fb398820a4cfede7d53740e45ccfe51eb37242cff5e616eb8c1d85f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e58913f5b3a8480d6669798ae8c08170df36adec1e578e88579abe3018bcb26"
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