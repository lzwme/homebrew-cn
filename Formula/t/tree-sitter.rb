class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "3cda4166a049fc736326941d6f20783b698518b0f80d8735c7754a6b2d173d9a"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8108dc08b2401166cf3d68ae4aa78ab86685a841a04581139d29e475b265d880"
    sha256 cellar: :any,                 arm64_sequoia: "c15a8755db277a5379e0880cefe11b9082cd60f2e7ef43b54b37e04aa6a7ffbc"
    sha256 cellar: :any,                 arm64_sonoma:  "ef3514b619e6f56870bdbcb8ce9fcc047fc1470a22a2cf029e431205bad72cce"
    sha256 cellar: :any,                 sonoma:        "e81fe9fe4c6e39b172e9d184cc8ce568845c6318258bbc0d7736c6589f41512d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a863dd1e11b224ebb61f5ecca232a2f0eea5eb87d3cd3774c7ae39ed4e65f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3479c317764bb6299d2e1748b21a54ec1bb501ee8016ab667c3b08568047509f"
  end

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      This formula now installs only the `tree-sitter` library (`libtree-sitter`).
      To install the CLI tool:
        brew install tree-sitter-cli
    EOS
  end

  test do
    (testpath/"test_program.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string successfully. But, we can verify
        // that it can at least be attempted.
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
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end