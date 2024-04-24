require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.16.4.tgz"
  sha256 "dbeb6d8e0e3990ba9c5bf4962088247fa8bd1aa4c6be652cba72a55836460a89"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71b7a2a255e89a64c84bde5ecb1e988c0dd39952428e3fe432cb0c9c64f87828"
    sha256 cellar: :any,                 arm64_ventura:  "71b7a2a255e89a64c84bde5ecb1e988c0dd39952428e3fe432cb0c9c64f87828"
    sha256 cellar: :any,                 arm64_monterey: "71b7a2a255e89a64c84bde5ecb1e988c0dd39952428e3fe432cb0c9c64f87828"
    sha256 cellar: :any,                 sonoma:         "324d30edb4e931a0c484cb9355d2ffeefb9470aca281a7a7084fd0347003b244"
    sha256 cellar: :any,                 ventura:        "324d30edb4e931a0c484cb9355d2ffeefb9470aca281a7a7084fd0347003b244"
    sha256 cellar: :any,                 monterey:       "324d30edb4e931a0c484cb9355d2ffeefb9470aca281a7a7084fd0347003b244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45ce225406f20764cae336f5a6dc87c419a56814078f97a62de308936415f3b"
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