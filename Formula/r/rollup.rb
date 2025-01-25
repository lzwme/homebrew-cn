class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.32.0.tgz"
  sha256 "d12f9205e741a3561d7ae2baaba03921102ea535fb6af061b9f2167f8d22c0f7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83d34190c25387d26ceb2cc2bab95d009d764707b3ee84a03f28f64b83d497c5"
    sha256 cellar: :any,                 arm64_sonoma:  "83d34190c25387d26ceb2cc2bab95d009d764707b3ee84a03f28f64b83d497c5"
    sha256 cellar: :any,                 arm64_ventura: "83d34190c25387d26ceb2cc2bab95d009d764707b3ee84a03f28f64b83d497c5"
    sha256 cellar: :any,                 sonoma:        "73d9575312b9b0ff3faf242f91567dbaf9a1f2c07a107dbdafc024159c5de5f9"
    sha256 cellar: :any,                 ventura:       "73d9575312b9b0ff3faf242f91567dbaf9a1f2c07a107dbdafc024159c5de5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5729fd6e6860b5cc63392190186a029720b5315b637004cbde3233a4c1108ada"
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