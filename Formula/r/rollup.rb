class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.48.1.tgz"
  sha256 "cf1b7ceb8ef6f38511ff78d766f9c04c5cf0dc4bbfa28e27e4d2086b9055e7ba"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c008e01bfcab0e5e165cbe65e1431d97f6ac38cbc9fba076c032a65b4daf07e"
    sha256 cellar: :any,                 arm64_sonoma:  "8c008e01bfcab0e5e165cbe65e1431d97f6ac38cbc9fba076c032a65b4daf07e"
    sha256 cellar: :any,                 arm64_ventura: "8c008e01bfcab0e5e165cbe65e1431d97f6ac38cbc9fba076c032a65b4daf07e"
    sha256 cellar: :any,                 sonoma:        "08e2ae51423ddfbfde2c713994177a92ea8707fcd1f87c0362d4f2646259fd86"
    sha256 cellar: :any,                 ventura:       "08e2ae51423ddfbfde2c713994177a92ea8707fcd1f87c0362d4f2646259fd86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e06c8362413ecf5064ee1b722978ff1bc0c679b8f265f828a9b38ad23785bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc0930ef964051900578ed94761fdcdb0c094aec23cb5f94e93492b9f75bd43b"
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