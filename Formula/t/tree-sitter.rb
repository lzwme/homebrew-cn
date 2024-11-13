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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b4932e1ed3dd2a8fef9ec480f3bf5175005badefa432f7f2f255cb648a032790"
    sha256 cellar: :any,                 arm64_sonoma:  "2008cda365e4dbf3e530236811fa37f2a14e65418fdf90e4b7dbd585a076325a"
    sha256 cellar: :any,                 arm64_ventura: "4c69b394b5dcff232bc9662abfa3d38865ce5d8aced92565107b1ced4a9666cb"
    sha256 cellar: :any,                 sonoma:        "9e10a26f5bd3d668720bb7cb152f9985fd0b758b07fbe7e56b3bc15c39172129"
    sha256 cellar: :any,                 ventura:       "037379b3381b736dc9cdb8109db8726a9f80cb8d785077f7b85bead89f910306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1887aaeef0cf0e07a7e8570332b875a70fd25a6cf0c18c76fe3a7a919a59f5d8"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  # The next three patches fix Neovim freezing in some configurations.
  # See: https:github.comneovimneovimissues31163
  #      https:github.comtree-sittertree-sitterissues3930
  #      https:github.comtree-sittertree-sitterpull3898
  # Remove in next release.
  patch do
    url "https:github.comtree-sittertree-sittercommitced69d59da9537abef13dbe027ee3a4a20e0ab77.patch?full_index=1"
    sha256 "f8440176a9354066bbe5e6eca535f7645ac9110d68f71cb903eb1b1d9f561773"
  end
  patch do
    url "https:github.comtree-sittertree-sittercommite6cb7f3f61cc99b78892a23ceb2cb2e8dde40a49.patch?full_index=1"
    sha256 "c84bda1fa49a88d41306d4fce6f128329c942403d16f1b75d7d4c2305c097eaa"
  end
  patch do
    url "https:github.comtree-sittertree-sittercommit455aa0d9b2d97514079783c7b7de718c0a148c5c.patch?full_index=1"
    sha256 "ce1cc2ebbad714c76fc12e74bb72a04f95dcccd474f4af1ef5ef23976624110c"
  end

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