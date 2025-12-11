class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "3cda4166a049fc736326941d6f20783b698518b0f80d8735c7754a6b2d173d9a"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7c719caad9841dfdb3f7ed4c5305cd3c82649ffa859e4f45a46fbf8e030038f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915628b12602559abe298fa5b3dbde49fafff516f5310b47ead10819eb5f375a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "023fdaf0d901bffc51f3e94542284deb2739bb56fb9cdabc2c1c6c227b3e76e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "de9f5f0694be1b112d79a0aff9ed90081e02b4ef4c2da45c23584eb39831327c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96abe563d42d927494d576ae6869a135d07eaa6e7ae47e660f7dbc08ab77b674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442c18f88462dfbfe873865b2f3d5189887e57b264e4a14ecc0c3dcbd06e2ab2"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  uses_from_macos "llvm" => :build

  link_overwrite "bin/tree-sitter"
  link_overwrite "etc/bash_completion.d/tree-sitter"
  link_overwrite "share/fish/vendor_completions.d/tree-sitter.fish", "share/zsh/site-functions/_tree-sitter"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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
    (testpath/"test/corpus/test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system bin/"tree-sitter", "test"
  end
end