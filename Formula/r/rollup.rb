class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.2.tgz"
  sha256 "067f2d6b75a2d87e5a01a26aaf1a2d01c95550cc0197627bd2f4f4cb415fb0a6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "cac1b2627529d499f6653827fc558886b5de99ff38fbd75bb93e861200012c0e"
    sha256 cellar: :any,                 arm64_tahoe:       "cac1b2627529d499f6653827fc558886b5de99ff38fbd75bb93e861200012c0e"
    sha256 cellar: :any,                 arm64_sequoia:     "cac1b2627529d499f6653827fc558886b5de99ff38fbd75bb93e861200012c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f13ea6a0739fa920d6b6b73cbc89e7881942ff2a785332b26e33a530c550947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "84c44de65585bdb33bcee030d1360127209c2ef30d5c9a723bf97d82dfea7057"
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