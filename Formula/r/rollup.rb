require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.13.2.tgz"
  sha256 "4969bc99a2db5e4cba5553499d840f92dca45ad0a48baec46ed78908bd253cea"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9a43868fd379281dd495d3d6ca63d60cf96f9a227e79bf1315ba52c9e57cf17"
    sha256 cellar: :any,                 arm64_ventura:  "b9a43868fd379281dd495d3d6ca63d60cf96f9a227e79bf1315ba52c9e57cf17"
    sha256 cellar: :any,                 arm64_monterey: "b9a43868fd379281dd495d3d6ca63d60cf96f9a227e79bf1315ba52c9e57cf17"
    sha256 cellar: :any,                 sonoma:         "a29877dba888e49ba09f141d650501cca408b7bc61fe589d8f0c8b82e8cedefa"
    sha256 cellar: :any,                 ventura:        "a29877dba888e49ba09f141d650501cca408b7bc61fe589d8f0c8b82e8cedefa"
    sha256 cellar: :any,                 monterey:       "a29877dba888e49ba09f141d650501cca408b7bc61fe589d8f0c8b82e8cedefa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd76ce9dd3d8fa8ad4e2b5f745f09d8d4f79d89737e0a49cdaf278ab70860e86"
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