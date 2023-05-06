require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.5.tgz"
  sha256 "2f8f5e9ffc974ae29c17fd9f1d0cc71be8250a93b3500d241700a246a4b6fd85"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "494396dbefdbe8246e6450c453bcf7a35e1174225e9aa62e032d9e6fd4cf9730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "494396dbefdbe8246e6450c453bcf7a35e1174225e9aa62e032d9e6fd4cf9730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "494396dbefdbe8246e6450c453bcf7a35e1174225e9aa62e032d9e6fd4cf9730"
    sha256 cellar: :any_skip_relocation, ventura:        "12f09b4e10c46e88061514df542d2862586159c8c8eb7b283b3af2e63be1686f"
    sha256 cellar: :any_skip_relocation, monterey:       "12f09b4e10c46e88061514df542d2862586159c8c8eb7b283b3af2e63be1686f"
    sha256 cellar: :any_skip_relocation, big_sur:        "12f09b4e10c46e88061514df542d2862586159c8c8eb7b283b3af2e63be1686f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34328393b56214134f3ebf839512680b8a85d5960d881ffe157636d195c6c97b"
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