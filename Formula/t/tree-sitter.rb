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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "04bc18658f2d1e9b4592c6b4aaad8b0f44e0a00fa800a1e553a7c9fa6eebaf04"
    sha256 cellar: :any,                 arm64_sonoma:  "98c9b5fd1cf1f2ae8c8c1708f72a121bffc263b804fc9ec60e2dd837f1637cf2"
    sha256 cellar: :any,                 arm64_ventura: "35880d964bd1cb4a2689c4adb50bdb274a5572274f5e45823405e37738c49083"
    sha256 cellar: :any,                 sonoma:        "8bf916cd0dd611f16c22a02dd9854d981930ce19d9c68b5ecef3faa12222cdbf"
    sha256 cellar: :any,                 ventura:       "29593b1fa35eaf34ac01b315945ba7fbd9bbfff3e2f8dc342b84242340b80777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f55ffdcbd243053eab62d2c8b6bb88d9c9785fcfa86a47c828ed5613a356651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1680c318ec34e97ad20729c9f501794621dc7e7d3c90823f0199a5e811d8e7"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin"tree-sitter", "complete", shell_parameter_format: :arg)
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