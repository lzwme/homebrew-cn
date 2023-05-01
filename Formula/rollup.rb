require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.2.tgz"
  sha256 "f23e2f143f33010044db25f9413db648a0580c7641789c8b641112d04e910d9a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28c56ed5bdcae60147dabc370907bf84bcdbbf720b618dc78243538362b984f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28c56ed5bdcae60147dabc370907bf84bcdbbf720b618dc78243538362b984f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c56ed5bdcae60147dabc370907bf84bcdbbf720b618dc78243538362b984f5"
    sha256 cellar: :any_skip_relocation, ventura:        "96b2054c922d0b6ab0a2b53b9a1c95b15a4ce53d635fd60fb28d084a8e34975e"
    sha256 cellar: :any_skip_relocation, monterey:       "96b2054c922d0b6ab0a2b53b9a1c95b15a4ce53d635fd60fb28d084a8e34975e"
    sha256 cellar: :any_skip_relocation, big_sur:        "96b2054c922d0b6ab0a2b53b9a1c95b15a4ce53d635fd60fb28d084a8e34975e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d556b14c2bb7784b2b3c53b26855698072b2c3fe967a1aa698398e3af0d2180"
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