class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "178b575244d967f4920a4642408dc4edf6de96948d37d7f06e5b78acee9c0b4e"
  license "MIT"
  revision 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9841c5b93cd0157cf9c02efe5050aff286fc83214430ccbadecc899a4b40973"
    sha256 cellar: :any,                 arm64_sonoma:  "9593afac488bb20dfaf32b35a97a3af0b8b02a262bf831687b366074f017581c"
    sha256 cellar: :any,                 arm64_ventura: "157886f003ff968de04d584dbc35aba727feaae3102b01188ec4f80ce9b34ee9"
    sha256 cellar: :any,                 sonoma:        "0cd18ea153dce11c64ebd6e2b708ba7e9169372a9979299959246ab76c540ae2"
    sha256 cellar: :any,                 ventura:       "ce995bb8e5855d84d468cfe88627ecb51ba39ceacf80c0e001f21cac4c0dc32a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a398e17148d29dae7b1ede9e256c7b44c595c883a41c1e03921dad94d1ddb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc166c9cac782e06d849cbb00cedabbe92f4050ce9d8d2eba8fc8d4624c8b61c"
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