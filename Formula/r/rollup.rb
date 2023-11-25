require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.5.2.tgz"
  sha256 "5e2ad56670dee84a34ca65e8fe8318935bddcb90b4b6adce43451dbd4bca0ebb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b1aab2621e30e38f7797131858faea24e1b292edcf1553de2c9f3d49e1daee35"
    sha256 cellar: :any,                 arm64_ventura:  "b1aab2621e30e38f7797131858faea24e1b292edcf1553de2c9f3d49e1daee35"
    sha256 cellar: :any,                 arm64_monterey: "b1aab2621e30e38f7797131858faea24e1b292edcf1553de2c9f3d49e1daee35"
    sha256 cellar: :any,                 sonoma:         "356429b14d584104dd1557420cb06b605c6676ddda69e5d26441f86282968519"
    sha256 cellar: :any,                 ventura:        "356429b14d584104dd1557420cb06b605c6676ddda69e5d26441f86282968519"
    sha256 cellar: :any,                 monterey:       "356429b14d584104dd1557420cb06b605c6676ddda69e5d26441f86282968519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8baf87e832acdfe65b854186f7bacfd545d5c91dd72f748f5ff49f7915e0fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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