require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.4.0.tgz"
  sha256 "3c600966b6c0f23a783f68fafb3a94a54fed768dcfebd39ae4d9c81193148eb9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a179ccca15a7142f88441e419228db3f7d8e8d64c32003061ff519d633918ca7"
    sha256 cellar: :any,                 arm64_ventura:  "a179ccca15a7142f88441e419228db3f7d8e8d64c32003061ff519d633918ca7"
    sha256 cellar: :any,                 arm64_monterey: "a179ccca15a7142f88441e419228db3f7d8e8d64c32003061ff519d633918ca7"
    sha256 cellar: :any,                 sonoma:         "004a88f66039764a806287cf8d91e28ba8ceba39fb875bf47da3d6000acbb5de"
    sha256 cellar: :any,                 ventura:        "004a88f66039764a806287cf8d91e28ba8ceba39fb875bf47da3d6000acbb5de"
    sha256 cellar: :any,                 monterey:       "004a88f66039764a806287cf8d91e28ba8ceba39fb875bf47da3d6000acbb5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e441df2d47680f423ffd36f3580a00ff53102ed495394194022cabeceaf9499"
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