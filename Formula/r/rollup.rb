class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.9.tgz"
  sha256 "12e1dfd9ece3065c211e991c0d1cc2a83ab1bce4d665705a301a0311cd4e960b"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26e2962f770f165713bbbbacbe8bef4cdcd76423ced15213c6c4185d2cbd8e65"
    sha256 cellar: :any,                 arm64_sonoma:  "26e2962f770f165713bbbbacbe8bef4cdcd76423ced15213c6c4185d2cbd8e65"
    sha256 cellar: :any,                 arm64_ventura: "26e2962f770f165713bbbbacbe8bef4cdcd76423ced15213c6c4185d2cbd8e65"
    sha256 cellar: :any,                 sonoma:        "6e4c638fcbc1a4c67b4fa14007b7be12877f6b1cac071063505da8085cdb3645"
    sha256 cellar: :any,                 ventura:       "6e4c638fcbc1a4c67b4fa14007b7be12877f6b1cac071063505da8085cdb3645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "958ed47fd03337bb36c6f9cc5aeaee7f00032fe4bb025a14afdd9d1d033593be"
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