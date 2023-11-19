require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.5.0.tgz"
  sha256 "76861a4f44ff208edea71e31b21e3862682376d3daa8b2931dab616f11287272"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "176d8c2864d7be5d3691e8d6bd306a009fbdc7ff7b58ad41b566f8c0dc9c146e"
    sha256 cellar: :any,                 arm64_ventura:  "176d8c2864d7be5d3691e8d6bd306a009fbdc7ff7b58ad41b566f8c0dc9c146e"
    sha256 cellar: :any,                 arm64_monterey: "176d8c2864d7be5d3691e8d6bd306a009fbdc7ff7b58ad41b566f8c0dc9c146e"
    sha256 cellar: :any,                 sonoma:         "6c04ae2c0763f4b589c1ab860b7110a8d77c242cb3bed107a4f425741f49b86f"
    sha256 cellar: :any,                 ventura:        "6c04ae2c0763f4b589c1ab860b7110a8d77c242cb3bed107a4f425741f49b86f"
    sha256 cellar: :any,                 monterey:       "6c04ae2c0763f4b589c1ab860b7110a8d77c242cb3bed107a4f425741f49b86f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104dd49b117470756d99ea379260ca5fcf5bfc96d86d2090128f330457285924"
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