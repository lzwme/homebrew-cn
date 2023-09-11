require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.29.1.tgz"
  sha256 "95785917dedaf303d23c74d7878a3db23f27e72d8c290bddcc7eaf706d0521be"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3becb18c381659799972142aea1a9f1f5d4fdd55fd52eb662db6fbe71fc26d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3becb18c381659799972142aea1a9f1f5d4fdd55fd52eb662db6fbe71fc26d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3becb18c381659799972142aea1a9f1f5d4fdd55fd52eb662db6fbe71fc26d84"
    sha256 cellar: :any_skip_relocation, ventura:        "b0571b0103c98d7479fa429baef0c2d3e98fc561e7f445db06c1400467cdd6e9"
    sha256 cellar: :any_skip_relocation, monterey:       "b0571b0103c98d7479fa429baef0c2d3e98fc561e7f445db06c1400467cdd6e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0571b0103c98d7479fa429baef0c2d3e98fc561e7f445db06c1400467cdd6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7acbbc16e2e70b04721a2ba65bd0b1f5746dddc10eafbbb2ab2d900e3289ab3d"
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