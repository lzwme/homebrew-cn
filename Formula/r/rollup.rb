require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.2.0.tgz"
  sha256 "b5b6f17b87ecfb042df484636e7dff2f1a95fd04e92b2377361701ad80c5a292"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79c4dcda0340854337e83e159df1f35df32ded4d91ffde25d42be5facb641a8e"
    sha256 cellar: :any,                 arm64_ventura:  "79c4dcda0340854337e83e159df1f35df32ded4d91ffde25d42be5facb641a8e"
    sha256 cellar: :any,                 arm64_monterey: "79c4dcda0340854337e83e159df1f35df32ded4d91ffde25d42be5facb641a8e"
    sha256 cellar: :any,                 sonoma:         "922e10e25f50c8f1475e83d857a639ca955709553b292733af6f105cd7fbebf5"
    sha256 cellar: :any,                 ventura:        "922e10e25f50c8f1475e83d857a639ca955709553b292733af6f105cd7fbebf5"
    sha256 cellar: :any,                 monterey:       "922e10e25f50c8f1475e83d857a639ca955709553b292733af6f105cd7fbebf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8db33448650a4f9ecca81edfc2283abc8bafbb6f3013a23b14db1fae9e3c80c"
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