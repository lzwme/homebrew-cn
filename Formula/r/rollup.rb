class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.46.0.tgz"
  sha256 "0f347b5a253d9f4cd4cb1ce1f86ca9d2ff46a6e8df0d2b27ef1003a006afadd9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3bcc491f535bd3a3c7b15cfaf5ee27d55d546d6337ce3a44468b8dc7ecb4b9d"
    sha256 cellar: :any,                 arm64_sonoma:  "f3bcc491f535bd3a3c7b15cfaf5ee27d55d546d6337ce3a44468b8dc7ecb4b9d"
    sha256 cellar: :any,                 arm64_ventura: "f3bcc491f535bd3a3c7b15cfaf5ee27d55d546d6337ce3a44468b8dc7ecb4b9d"
    sha256 cellar: :any,                 sonoma:        "b4526d64dcf9583d8790e20140a945d10f25d0e9d1136a367377655564c29c58"
    sha256 cellar: :any,                 ventura:       "b4526d64dcf9583d8790e20140a945d10f25d0e9d1136a367377655564c29c58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382b67d5d7523732c5b4b98636b8c1fdf8dd6a6102593943ca8ec06fb7822527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cb59333ec35e846466c975c5dbd6e36b995f03b0dcf40c594e0e5162cefc41"
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