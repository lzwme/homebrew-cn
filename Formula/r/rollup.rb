class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.30.1.tgz"
  sha256 "9181b854339e701acdc4e190116c00a86a99ffea4474f373ba956de63a7b61d4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27ac63614f65b93102b12a424bd0600fed29a9e78366c0c9de5a6229f6532d65"
    sha256 cellar: :any,                 arm64_sonoma:  "27ac63614f65b93102b12a424bd0600fed29a9e78366c0c9de5a6229f6532d65"
    sha256 cellar: :any,                 arm64_ventura: "27ac63614f65b93102b12a424bd0600fed29a9e78366c0c9de5a6229f6532d65"
    sha256 cellar: :any,                 sonoma:        "0ff18c97e0897a1bd69048b75061f434afbe5ef8154920ea06b26851502ecfaa"
    sha256 cellar: :any,                 ventura:       "0ff18c97e0897a1bd69048b75061f434afbe5ef8154920ea06b26851502ecfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2d47f3c8be6e70e28af1914baf8a1dc7287f6d784175e877cf98296561acb19"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end