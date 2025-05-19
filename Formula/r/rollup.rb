class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.41.0.tgz"
  sha256 "d1a28d625e6312b541d4cd8f2f4bec68f2aab8a64aa71db50868130eb859446d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a97f8698218e9f68863375de278b01df423d89670001ebbeef2a310747cd8aac"
    sha256 cellar: :any,                 arm64_sonoma:  "a97f8698218e9f68863375de278b01df423d89670001ebbeef2a310747cd8aac"
    sha256 cellar: :any,                 arm64_ventura: "a97f8698218e9f68863375de278b01df423d89670001ebbeef2a310747cd8aac"
    sha256 cellar: :any,                 sonoma:        "b0d8937bc28983b799965be33221d45553583c0dd3ea6d005b136797527b9e5b"
    sha256 cellar: :any,                 ventura:       "b0d8937bc28983b799965be33221d45553583c0dd3ea6d005b136797527b9e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "462e0f1fabba38ff9ae7c423d5380ff594a460c2bca0635cb98f328e3d67f250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f9e519077030a79d75b77472339fc249fea25bbba599ccc81f2a00b964163f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end