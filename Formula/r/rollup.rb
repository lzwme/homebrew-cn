class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.7.tgz"
  sha256 "4dd0f91845ad00a50cce43f5f6c40bd1e8e7af0a750272904e36936b7f937f4e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "294bd7942fb523c5103e73f7d8dc18db522338c07fd5a0ba094f3cfd60ccca5b"
    sha256 cellar: :any,                 arm64_sonoma:  "294bd7942fb523c5103e73f7d8dc18db522338c07fd5a0ba094f3cfd60ccca5b"
    sha256 cellar: :any,                 arm64_ventura: "294bd7942fb523c5103e73f7d8dc18db522338c07fd5a0ba094f3cfd60ccca5b"
    sha256 cellar: :any,                 sonoma:        "61a4b25b88ce3c7264de136220cccf37a455cbf19f25a814454c0b208c1a1dd8"
    sha256 cellar: :any,                 ventura:       "61a4b25b88ce3c7264de136220cccf37a455cbf19f25a814454c0b208c1a1dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58dec1e80ddaee8cceab8ec7664bc8902fe6ed95bb4e487cdedfb71b658fbc5"
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