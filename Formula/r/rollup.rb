class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.65.1.tgz"
  sha256 "dd3ac7c94fad7f8dfcce4798a09f77db6f19e7b5e7d9ad191f2cc733bf33d7fe"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0a4d0725d0240f6441e6fab23f8408d68842f401cb3e49eaae7778ac7e52396a"
    sha256 cellar: :any,                 arm64_tahoe:       "0a4d0725d0240f6441e6fab23f8408d68842f401cb3e49eaae7778ac7e52396a"
    sha256 cellar: :any,                 arm64_sequoia:     "0a4d0725d0240f6441e6fab23f8408d68842f401cb3e49eaae7778ac7e52396a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "353a919f8998cee203a56d3e14215f14b630529288dfe437c7c1e97a28921771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "63bc4c664bf84641fa4673a49325e35fa86eaa22b9bbc91eeb4353e1cb146e73"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
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