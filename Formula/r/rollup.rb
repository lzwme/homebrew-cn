class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.3.tgz"
  sha256 "84abad2abd05ef0909b508a8d2a4c2bc23433a783600defae2363e8aa6467e11"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1f36e06e25f6379bc63e4703138bc0a421b5f39c2e5bf7be53139fadd32744d5"
    sha256 cellar: :any,                 arm64_tahoe:       "1f36e06e25f6379bc63e4703138bc0a421b5f39c2e5bf7be53139fadd32744d5"
    sha256 cellar: :any,                 arm64_sequoia:     "1f36e06e25f6379bc63e4703138bc0a421b5f39c2e5bf7be53139fadd32744d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "68101052291c7fa04116e84833ce422c5fdcf907267762dc5f9d265a2b487139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8ba3458929f112c870e4fa827e2684219eb89ddcc6d7f310c62b954eaffd2c87"
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