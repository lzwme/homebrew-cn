class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.52.0.tgz"
  sha256 "b046c5507989ef2ab1692a305cb9368b4e5d25af6e828c4026a7d232c36f33a2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35a1f33c89de48dca409263c8d6593efc1af46e18ae0d5870aeafb6bd5ea1e22"
    sha256 cellar: :any,                 arm64_sequoia: "02fa6de5348536aaadf94c27a243121d02b67be124fc717e3e648b5406a7725a"
    sha256 cellar: :any,                 arm64_sonoma:  "02fa6de5348536aaadf94c27a243121d02b67be124fc717e3e648b5406a7725a"
    sha256 cellar: :any,                 sonoma:        "9f51c687e5666725e2c49514b1c1a80519ca4dcdf4091722f70afef1ff4f1646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331fcf68a3e16058b2a52a04f88cd4570b7f377b430f36d7cf9c7760b8eb4e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59d0a86d02d188363d51caa6a1fd1891148168e22f6c4a2f10718ac6769ef19"
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