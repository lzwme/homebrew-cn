require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.27.1.tgz"
  sha256 "9c30747802aa0e5737e68364b375bad47261167916fc88851f4fe0086f2e3c30"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0738719bf5d5eb34449d7ab0abf8380797c87c90e4ec4fd1d79bfbfe79214a15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0738719bf5d5eb34449d7ab0abf8380797c87c90e4ec4fd1d79bfbfe79214a15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0738719bf5d5eb34449d7ab0abf8380797c87c90e4ec4fd1d79bfbfe79214a15"
    sha256 cellar: :any_skip_relocation, ventura:        "1d3919fa7091c220cb9b8f864795d12090a94532c338b5c9ec43748bea865a78"
    sha256 cellar: :any_skip_relocation, monterey:       "1d3919fa7091c220cb9b8f864795d12090a94532c338b5c9ec43748bea865a78"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d3919fa7091c220cb9b8f864795d12090a94532c338b5c9ec43748bea865a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35adccdcc461243704fe323c518af0e3f8a62b94f0c4ccfc27582f6e30a75e35"
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