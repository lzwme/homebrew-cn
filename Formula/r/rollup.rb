class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.29.0.tgz"
  sha256 "7814f913d1ec43d20d4d8f9da0762465a56b2debd0375c09a851b40af5f44d38"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f54e2fdb0f428b1963d913edfd8ac25807c4dd66d32d0d0a5d25d36a63933bd2"
    sha256 cellar: :any,                 arm64_sonoma:  "f54e2fdb0f428b1963d913edfd8ac25807c4dd66d32d0d0a5d25d36a63933bd2"
    sha256 cellar: :any,                 arm64_ventura: "f54e2fdb0f428b1963d913edfd8ac25807c4dd66d32d0d0a5d25d36a63933bd2"
    sha256 cellar: :any,                 sonoma:        "1050c1fca8f688ee0772c0f54664118e2e2c7842c546c93323f3bf7b31a6b725"
    sha256 cellar: :any,                 ventura:       "1050c1fca8f688ee0772c0f54664118e2e2c7842c546c93323f3bf7b31a6b725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec9fe1415261f34e11106adb8be03271940ba97facf9815aa27950782a8de49"
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