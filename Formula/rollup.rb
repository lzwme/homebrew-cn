require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.24.1.tgz"
  sha256 "1fc86d0501d2242e6e4a9a5ae4b66bf5252e708885d83a568da83cf805152b7a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3bc24fe05a1942151e15fc446fc62f87cc348ea9e8d1934a431bc49c2bb784a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3bc24fe05a1942151e15fc446fc62f87cc348ea9e8d1934a431bc49c2bb784a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3bc24fe05a1942151e15fc446fc62f87cc348ea9e8d1934a431bc49c2bb784a"
    sha256 cellar: :any_skip_relocation, ventura:        "9e58e91f4a0973936717429e7509ad0f571a41e6ec317ca5f83074d4abcc2a8c"
    sha256 cellar: :any_skip_relocation, monterey:       "9e58e91f4a0973936717429e7509ad0f571a41e6ec317ca5f83074d4abcc2a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e58e91f4a0973936717429e7509ad0f571a41e6ec317ca5f83074d4abcc2a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d5de0af02bcf11bafafe345ffe4476b395de64094cc7853bc3387ffeef601fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end