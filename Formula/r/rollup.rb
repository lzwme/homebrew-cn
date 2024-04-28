require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.17.0.tgz"
  sha256 "6ee173c8778e9c4f7dfee86a005603a2c529af47cdd38f64d6bd68297287cf78"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab16e93decd249d3ad8599e0ece6592d8d8d146caf8528c9f8ef65a990aedb25"
    sha256 cellar: :any,                 arm64_ventura:  "ab16e93decd249d3ad8599e0ece6592d8d8d146caf8528c9f8ef65a990aedb25"
    sha256 cellar: :any,                 arm64_monterey: "ab16e93decd249d3ad8599e0ece6592d8d8d146caf8528c9f8ef65a990aedb25"
    sha256 cellar: :any,                 sonoma:         "a63a616a8ea21058a6f3314373f1b57e46649d692759171a5b4491b1dae8cf8e"
    sha256 cellar: :any,                 ventura:        "a63a616a8ea21058a6f3314373f1b57e46649d692759171a5b4491b1dae8cf8e"
    sha256 cellar: :any,                 monterey:       "a63a616a8ea21058a6f3314373f1b57e46649d692759171a5b4491b1dae8cf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "337032a64be6b9e5ed905137fc687e718088862283d2c5bf8e9c2c2f9e005e97"
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