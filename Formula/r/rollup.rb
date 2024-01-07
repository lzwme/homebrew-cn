require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.4.tgz"
  sha256 "ed6ec07907c1ad0b5d6b41948c4217cd453741611a270f30d8a625ba40713e70"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2674d9662d830e755903de603bc0cd1be8ecac7ab9f7eb6cab35d0ac1582336"
    sha256 cellar: :any,                 arm64_ventura:  "a2674d9662d830e755903de603bc0cd1be8ecac7ab9f7eb6cab35d0ac1582336"
    sha256 cellar: :any,                 arm64_monterey: "a2674d9662d830e755903de603bc0cd1be8ecac7ab9f7eb6cab35d0ac1582336"
    sha256 cellar: :any,                 sonoma:         "a26241e43866a2ba5330377f3c35a1614742381ce82d7c82e272a0dd1d9416a4"
    sha256 cellar: :any,                 ventura:        "a26241e43866a2ba5330377f3c35a1614742381ce82d7c82e272a0dd1d9416a4"
    sha256 cellar: :any,                 monterey:       "a26241e43866a2ba5330377f3c35a1614742381ce82d7c82e272a0dd1d9416a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390d887ac1f43fa5da2a2b8044cf327a714874ca5ec5b22ab862b0f57fad3999"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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