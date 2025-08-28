class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.49.0.tgz"
  sha256 "108d4132ccdbba5c92f469991fddf31e53264083e4d41ef1a398f1ddc92957d9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b315d94740dc9e4efa13f498763ab27f509681b64833ddbdda6549fb95bd8e8c"
    sha256 cellar: :any,                 arm64_sonoma:  "b315d94740dc9e4efa13f498763ab27f509681b64833ddbdda6549fb95bd8e8c"
    sha256 cellar: :any,                 arm64_ventura: "b315d94740dc9e4efa13f498763ab27f509681b64833ddbdda6549fb95bd8e8c"
    sha256 cellar: :any,                 sonoma:        "48c3cf8d025387fe071ce1dcf7f6ed4685499e9f0031d7a73c22f683ee7662ad"
    sha256 cellar: :any,                 ventura:       "48c3cf8d025387fe071ce1dcf7f6ed4685499e9f0031d7a73c22f683ee7662ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "022031caf7e01a5e154e1d7d82700c8d9c211c42d6aab9ae286b5801bc2dc295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0761152156a33eccc17d57a56f27f40c6cb9af14b678d8b474b59424184bf448"
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