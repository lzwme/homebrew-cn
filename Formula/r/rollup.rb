class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.45.1.tgz"
  sha256 "7603e161da1c615b6e6f63a9b6d51d1cb9eae5cc989aa14e05f13b43cc81c7b4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "842ffe20ff0f8c07aa65481a68503140b10c52ac56eb51f8da42b81297d3bb01"
    sha256 cellar: :any,                 arm64_sonoma:  "842ffe20ff0f8c07aa65481a68503140b10c52ac56eb51f8da42b81297d3bb01"
    sha256 cellar: :any,                 arm64_ventura: "842ffe20ff0f8c07aa65481a68503140b10c52ac56eb51f8da42b81297d3bb01"
    sha256 cellar: :any,                 sonoma:        "77c11a2635e9eb35b61e494e2f4015aa60a5513745e433ed387c6563271b5212"
    sha256 cellar: :any,                 ventura:       "77c11a2635e9eb35b61e494e2f4015aa60a5513745e433ed387c6563271b5212"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7323393f993cddcf14ddf4401d67a10fd7941a9795209528a0753cca10c34eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e564cf1b101ffcb159459fc31658c6966063e973f4c0af6ce4df8048a79fedb6"
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