require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.25.2.tgz"
  sha256 "5d6b54899f055749568825066cd40768f517e9e88f21bff21b7c96f17475804a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "943163c771d09c63cef96dee76cbce912ec0a64c0e1124405ba0ad27b990828b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "943163c771d09c63cef96dee76cbce912ec0a64c0e1124405ba0ad27b990828b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "943163c771d09c63cef96dee76cbce912ec0a64c0e1124405ba0ad27b990828b"
    sha256 cellar: :any_skip_relocation, ventura:        "24f9b1970fff25774cc3413625443dd550327c7fb43a1ad08bd1f2a3cffbfd44"
    sha256 cellar: :any_skip_relocation, monterey:       "24f9b1970fff25774cc3413625443dd550327c7fb43a1ad08bd1f2a3cffbfd44"
    sha256 cellar: :any_skip_relocation, big_sur:        "24f9b1970fff25774cc3413625443dd550327c7fb43a1ad08bd1f2a3cffbfd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "498303a2d41fbb5ca363a05b79b8bc3701e1ab0df879fc0b5db30d5a61d946e3"
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