class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.6.tgz"
  sha256 "00ac7de7a8c0770967cc655a4555ba0c5d4aa3d5cc3bdba148326990def6b6c4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6806b4597da94e3917c1043420d2af522e3c583121452e1f6660b70e27ed9158"
    sha256 cellar: :any,                 arm64_tahoe:       "6806b4597da94e3917c1043420d2af522e3c583121452e1f6660b70e27ed9158"
    sha256 cellar: :any,                 arm64_sequoia:     "6806b4597da94e3917c1043420d2af522e3c583121452e1f6660b70e27ed9158"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1927822700d86ef136819a3497b8c07b3330cc759af2788c2793a00239fc41c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8be2274fe3ab960c810645413251172590caf156e72b4b0d4cb2a133ecda789c"
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