require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.15.0.tgz"
  sha256 "b6c02673454c4456fd25b8478eef0e471ae74d0ca85f3116a310962660e714ba"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "917c697f636d1e28c67751dc5f44d9af95767a85d34bc2d631b1b717e708ee9f"
    sha256 cellar: :any,                 arm64_ventura:  "917c697f636d1e28c67751dc5f44d9af95767a85d34bc2d631b1b717e708ee9f"
    sha256 cellar: :any,                 arm64_monterey: "917c697f636d1e28c67751dc5f44d9af95767a85d34bc2d631b1b717e708ee9f"
    sha256 cellar: :any,                 sonoma:         "e02b65c57cd9de99b534f537edff8e5cdd39ce4d70901a03b6c97158647477a6"
    sha256 cellar: :any,                 ventura:        "e02b65c57cd9de99b534f537edff8e5cdd39ce4d70901a03b6c97158647477a6"
    sha256 cellar: :any,                 monterey:       "e02b65c57cd9de99b534f537edff8e5cdd39ce4d70901a03b6c97158647477a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2126177f7f75370b1d40a54e60f6028fdefa437d681b38f761b6da4f43fa77f0"
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