require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.7.0.tgz"
  sha256 "7782b9cdd6724c6f1f966098a5e1c3fee4ee4912366d5a29dbd3bae64df9fe4a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f027edf56b11d97c5ee284ae25ed60bcb889c46c3fa92817cdb4f54313acbaed"
    sha256 cellar: :any,                 arm64_ventura:  "f027edf56b11d97c5ee284ae25ed60bcb889c46c3fa92817cdb4f54313acbaed"
    sha256 cellar: :any,                 arm64_monterey: "f027edf56b11d97c5ee284ae25ed60bcb889c46c3fa92817cdb4f54313acbaed"
    sha256 cellar: :any,                 sonoma:         "dbdc175e2a484374adc60a6516a02e44263ddf2b4ad15e6e8bd0718eca487229"
    sha256 cellar: :any,                 ventura:        "dbdc175e2a484374adc60a6516a02e44263ddf2b4ad15e6e8bd0718eca487229"
    sha256 cellar: :any,                 monterey:       "dbdc175e2a484374adc60a6516a02e44263ddf2b4ad15e6e8bd0718eca487229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a5702943b9370b2402a164bcbe992d7d83d056cd081c90c08c627202bb45f7"
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