class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "b4218185a48a791d4022ab3969709e271a70a0253e94792abbcf18d7fcf4291c"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ffa5c913de28a668be55b88b1ec4da3c78c2c36d4799aaf09fa3f81f3f4787c"
    sha256 cellar: :any,                 arm64_sequoia: "df89c0e3d5826a4fca37f8dc312dfc67a0fc5c9d39348ee480a9b57a7c471b71"
    sha256 cellar: :any,                 arm64_sonoma:  "91a6fdb54f33aeedb87c292b81ff6115cae4c26e6f4538f403cd03ed8cca70a9"
    sha256 cellar: :any,                 sonoma:        "838ce0601f02d1ef61f020b2fc513b17c1f7e75cc226695660bbaf8007d971f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33a4c01f3269cadfd7384fdf200eed0e7bc0c6c3184cbaf6d5826184cee23e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7fa92599098a02486788ff3180a686acfa4f9aa0bb611e6af1bd15a7a9b1f84"
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