class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "ef9d1afe8e81a508c28e529101f28ad38b785daf3acc0a2f707d00e8c4a498a8"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12415078ba891baa84ebb87655433952b7cb3f98d92bbc9a5f670b4046835f61"
    sha256 cellar: :any,                 arm64_sonoma:  "b74a41074bcfbc14f9950a547d8e89a8aad217402aaedfb896c33fec00d250b6"
    sha256 cellar: :any,                 arm64_ventura: "15d7e60325ee0e40414c0c1ddc4f7fb04f7a51486e3c3076157833645a746057"
    sha256 cellar: :any,                 sonoma:        "07b3536889d426757c993dcee726c0c57df3183dc732211352924c796c766f82"
    sha256 cellar: :any,                 ventura:       "e7c5dbe99e123181184d8ec7e594166fecfe897700219473104163f7aca3fb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69acef89de8226190ca59ba75f0ac8d7d4c60033c68a450139b4ffa3f44c3af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e82e3390da340c9b14bbe7cfe23579c1732dfa6d25878a5b6ab61edc65af720"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"tree-sitter", "complete", shell_parameter_format: :arg)
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}/tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath/"grammar.js").write <<~JS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    JS
    system bin/"tree-sitter", "generate", "--abi=latest"

    # test `tree-sitter parse`
    (testpath/"test/corpus/hello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}/tree-sitter parse #{testpath}/test/corpus/hello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath/"test"/"corpus"/"test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system bin/"tree-sitter", "test"

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