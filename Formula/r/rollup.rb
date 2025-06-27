class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.44.1.tgz"
  sha256 "20a63906ba831de394bbc6b588047e50d161360592da6237d576d63fd0576fce"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a3a9c03b611402ba9c97251ce52c955408b4a4f6507fc7af17e8bb3b1692820"
    sha256 cellar: :any,                 arm64_sonoma:  "2a3a9c03b611402ba9c97251ce52c955408b4a4f6507fc7af17e8bb3b1692820"
    sha256 cellar: :any,                 arm64_ventura: "2a3a9c03b611402ba9c97251ce52c955408b4a4f6507fc7af17e8bb3b1692820"
    sha256 cellar: :any,                 sonoma:        "6a5ce4c41d6b419a85f1fe41eba0b3e1221fae9e627d87fc7035be37e16e7bb0"
    sha256 cellar: :any,                 ventura:       "6a5ce4c41d6b419a85f1fe41eba0b3e1221fae9e627d87fc7035be37e16e7bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece2b58e00d1fcb74c911d20df9a462d8929bf6733b407eb57b5463a15591cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b1f37867b03574b42d6f48719292974b05edf836a172f9584aa20aeb34524a1"
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