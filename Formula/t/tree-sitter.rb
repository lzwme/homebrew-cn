class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "ac6ed919c6d849e8553e246d5cd3fa22661f6c7b6497299264af433f3629957c"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0bbb0c481ba1bbf10034f02dbc35706ac90feb75a32d74479949f40b445dddc"
    sha256 cellar: :any,                 arm64_sonoma:  "9783390a41db3df81c8e8ea7821e3fed961e3f555ec7ad7cdc3b898ec83456ac"
    sha256 cellar: :any,                 arm64_ventura: "acf486817e07c7a3956657e79f7f6fb7911eebf3f4f10c838893302ff351b594"
    sha256 cellar: :any,                 sonoma:        "81facd00d0a0dd7fc94ed871d0dc42edec9fd2c995c06fd74a27972a77afdd05"
    sha256 cellar: :any,                 ventura:       "6e0de41547ec2c1f73d0b196b5f93593ae4d59a8bb29472f532662b63f0a3868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98aad9636a33ade7ea48df074a249b7afbac23b176603bec1316090376556eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7874824fe9651b94a3afd8207beb33b7facdf2faddc75f5c9844fe12bdec21a"
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