require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.6.1.tgz"
  sha256 "d60345d93390409e6c459784e675e883b37b2b0e92bc8cf95a2f99b1493946d5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e8255e41399813641c41928266714c8e08b053335d1e10f7ae8046237530bf1"
    sha256 cellar: :any,                 arm64_ventura:  "6e8255e41399813641c41928266714c8e08b053335d1e10f7ae8046237530bf1"
    sha256 cellar: :any,                 arm64_monterey: "6e8255e41399813641c41928266714c8e08b053335d1e10f7ae8046237530bf1"
    sha256 cellar: :any,                 sonoma:         "b3220c7391494a7a3e4edc5dafd1bf721030d7f85114382b5a474e1530832195"
    sha256 cellar: :any,                 ventura:        "b3220c7391494a7a3e4edc5dafd1bf721030d7f85114382b5a474e1530832195"
    sha256 cellar: :any,                 monterey:       "b3220c7391494a7a3e4edc5dafd1bf721030d7f85114382b5a474e1530832195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf00cf4ba3f6a91b8b1aa8f80d7d0ce593e7d3a52c5d62257c8b3a45be4e5b41"
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