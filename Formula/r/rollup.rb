class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.28.0.tgz"
  sha256 "f2908dafef0e86ed2ffd4db6330320b43090bbf630e4f5a24c440535d62eddd4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93ec0a2dbbd6a116e5ca3dc1e33e8e04b2d472fd4a196a4927e8ce3785c9e290"
    sha256 cellar: :any,                 arm64_sonoma:  "93ec0a2dbbd6a116e5ca3dc1e33e8e04b2d472fd4a196a4927e8ce3785c9e290"
    sha256 cellar: :any,                 arm64_ventura: "93ec0a2dbbd6a116e5ca3dc1e33e8e04b2d472fd4a196a4927e8ce3785c9e290"
    sha256 cellar: :any,                 sonoma:        "79c50f2ad907a3e8b06145008de8c1f108b518ada655ba0d92defb2b1c3ca798"
    sha256 cellar: :any,                 ventura:       "79c50f2ad907a3e8b06145008de8c1f108b518ada655ba0d92defb2b1c3ca798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9160ac295e91427fe67482d9150a0159d9e884cffbc1ada3782b23b9f8c4479f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
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