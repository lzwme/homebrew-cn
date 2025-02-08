class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.6.tgz"
  sha256 "e2fa596a124e111537c619b517b36b3e135c800b643be91bb504799edb110ff7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f12a00f6737af6ab2e5891d00b7f7b8758c66b66f0bcf65185debdaf68bd4b44"
    sha256 cellar: :any,                 arm64_sonoma:  "f12a00f6737af6ab2e5891d00b7f7b8758c66b66f0bcf65185debdaf68bd4b44"
    sha256 cellar: :any,                 arm64_ventura: "f12a00f6737af6ab2e5891d00b7f7b8758c66b66f0bcf65185debdaf68bd4b44"
    sha256 cellar: :any,                 sonoma:        "348f6e8508b88d7e32b68e1217aebb7e2bdb54f522fb094b3a86fe859d900d2d"
    sha256 cellar: :any,                 ventura:       "348f6e8508b88d7e32b68e1217aebb7e2bdb54f522fb094b3a86fe859d900d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc2105e6e1754f83054bb49244bbbb4ddc0cdaed38cf7248c18ca5631670a8ee"
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