class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "b4218185a48a791d4022ab3969709e271a70a0253e94792abbcf18d7fcf4291c"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ccdff066d27a117e1700bd004de38290fd9e73610ff67ee3b0745520fc65e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5021922d801a428223bdad80c03218ff78324b7e1cb6b6838bbab602b3522ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f6c9b09e2490ce819e9ffb79cac0575caf3f5983d5118d36fbceb2a07fa4832"
    sha256 cellar: :any_skip_relocation, sonoma:        "0511253f3446d0b9f6124ccf7e51de1b33b642827abd4737ccec6071e6ee3313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe6de912b8e10fb3c791d0c05ba1240641ba41d68cc67ddfd9139d1f4f40f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789d325c2bc2ab197f5ebc972dd16bac2e81de93587ed76ef36c7f4240ce0396"
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