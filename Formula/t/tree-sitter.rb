class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https:tree-sitter.github.io"
  url "https:github.comtree-sittertree-sitterarchiverefstagsv0.25.4.tar.gz"
  sha256 "87eadc505905c70a692917c821958a819903f808f8d244068b1d273a033dc728"
  license "MIT"
  head "https:github.comtree-sittertree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d759e793e811053e350f19269066d86609efa06fc2e92ce7085b413dc3baab70"
    sha256 cellar: :any,                 arm64_sonoma:  "1a0a7a12a4021659fd237f7b35abb449f179dff95b059ce874997a2d65b0a042"
    sha256 cellar: :any,                 arm64_ventura: "7605faf1b7a973d90c481477a400b2b4da5a18adfdcaabfb9868075a84eef99f"
    sha256 cellar: :any,                 sonoma:        "873e4f49b4c0419ff3f5ff2d7f44c63068a9de9d3100f3f811b04e6d01f05d17"
    sha256 cellar: :any,                 ventura:       "96ef7b42541f6cdc3eb3d06137a6cc077b981549c22d397bb7a9460b20073e29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb5af21cb73a0a56b5980663f9640c3d897c020bf3c5457d11b471f6f5cd467f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51edea22da451343dd7f18b7d92908158ed96c0f6c74e24e3a373baffaddc538"
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