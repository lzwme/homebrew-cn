class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "178b575244d967f4920a4642408dc4edf6de96948d37d7f06e5b78acee9c0b4e"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2615238d4a932ee7a550db42effff9d9d49c7590a3de0fd97d2c879740fd0fdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85273cb2a0aa29d9785528712183035eb8e7b4b5eb4ff8938138042b5108c611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7f61b809edc4fe3b785eef572660ad51924ac68224c83bbe0f6b20dc63bdc96"
    sha256 cellar: :any_skip_relocation, sonoma:        "c88404760d85f3003595f6a4670d52e13b909bfcfd58ebd521b937fe9d0a2dbe"
    sha256 cellar: :any_skip_relocation, ventura:       "e6aad9ea772bab13654df20dc4a4a59b94ff6ded659b35629029edee39dd969f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b77a715803dc1553f1ee33de4522a22eca3ae8418df0ce9cd915e8625b55d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab88f0fe5a45d8bcb368e5359066fc1dec7a8a7aa2278996ec76a136ad452c2"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  link_overwrite "bin/tree-sitter"
  link_overwrite "etc/bash_completion.d/tree-sitter"
  link_overwrite "share/fish/vendor_completions.d/tree-sitter.fish", "share/zsh/site-functions/_tree-sitter"

  def install
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
  end
end