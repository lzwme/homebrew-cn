require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.0.tgz"
  sha256 "0ab1e0e19e7162c8876dfbc9df208e566c43232478b92caec84d9d73aab344e4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d956e6ebb71b0216d7abd0b94a1854940d8a016264f0fd8ec2d01439a11f6c98"
    sha256 cellar: :any,                 arm64_ventura:  "d956e6ebb71b0216d7abd0b94a1854940d8a016264f0fd8ec2d01439a11f6c98"
    sha256 cellar: :any,                 arm64_monterey: "d956e6ebb71b0216d7abd0b94a1854940d8a016264f0fd8ec2d01439a11f6c98"
    sha256 cellar: :any,                 sonoma:         "d9f2c86f3be6091508e63195d20e3e88451fd74adb3ccd1faeace4a83f2def5f"
    sha256 cellar: :any,                 ventura:        "d9f2c86f3be6091508e63195d20e3e88451fd74adb3ccd1faeace4a83f2def5f"
    sha256 cellar: :any,                 monterey:       "d9f2c86f3be6091508e63195d20e3e88451fd74adb3ccd1faeace4a83f2def5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0998320a8f75ef4fb16bdcb5d986eaa6f7b96829102c7ea3c8915ba298a1167"
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