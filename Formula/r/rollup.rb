require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.29.2.tgz"
  sha256 "7511e4bdd2e0c7b69711fd5a37de0a36e1c02554f9f9bd137333b52b4c5fe9ea"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a487e48e2eca76f36ac581d108b901454bf3093286f498a06f1cbb83b4c82718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a487e48e2eca76f36ac581d108b901454bf3093286f498a06f1cbb83b4c82718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a487e48e2eca76f36ac581d108b901454bf3093286f498a06f1cbb83b4c82718"
    sha256 cellar: :any_skip_relocation, ventura:        "1cc6e55e803c8f5b1df70998aacc54802fccad9f892c334268ac14eb76980a36"
    sha256 cellar: :any_skip_relocation, monterey:       "1cc6e55e803c8f5b1df70998aacc54802fccad9f892c334268ac14eb76980a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cc6e55e803c8f5b1df70998aacc54802fccad9f892c334268ac14eb76980a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "738f94af10a6e8c785577d9c4d809bc25ca00099b6bf8b197092479c259e273c"
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