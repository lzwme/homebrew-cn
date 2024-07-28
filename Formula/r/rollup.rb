require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.19.1.tgz"
  sha256 "a9c56f2142275296eff9fa2bf409ef3cd8b998ff6f5fd42b8c1e40b3502d2713"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "866eddcb2caaa63cdf49da9dfda08f678d3d64a8f1f90dd580622bf30d2ef45c"
    sha256 cellar: :any,                 arm64_ventura:  "866eddcb2caaa63cdf49da9dfda08f678d3d64a8f1f90dd580622bf30d2ef45c"
    sha256 cellar: :any,                 arm64_monterey: "866eddcb2caaa63cdf49da9dfda08f678d3d64a8f1f90dd580622bf30d2ef45c"
    sha256 cellar: :any,                 sonoma:         "f3a70063448dded401762d2ed1c3089383ce6920c0b58c393374af8b279849f6"
    sha256 cellar: :any,                 ventura:        "f3a70063448dded401762d2ed1c3089383ce6920c0b58c393374af8b279849f6"
    sha256 cellar: :any,                 monterey:       "f3a70063448dded401762d2ed1c3089383ce6920c0b58c393374af8b279849f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e44d3acb264719d51b80c18e576a2789a49140a632decc222a8c5fd3d4e3ad"
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