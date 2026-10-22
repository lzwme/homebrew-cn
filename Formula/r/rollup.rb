class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.12.tgz"
  sha256 "28ab6933db9f89bdbe9a0cb477fe042ca5bee7f847a957b5ff278aea4638327c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "08fb30127f167612d28f4f265cfb7107b803d128d009ab82590e014e195d202f"
    sha256 cellar: :any,                 arm64_tahoe:       "08fb30127f167612d28f4f265cfb7107b803d128d009ab82590e014e195d202f"
    sha256 cellar: :any,                 arm64_sequoia:     "08fb30127f167612d28f4f265cfb7107b803d128d009ab82590e014e195d202f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66e2205a293525e75aca18934e9a0c515d77de9f57dfe97e1655d2be11a46fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a2d0ba42277d47fec5d0298c7910db1449a17185475cfd50078cc591a8adf2dd"
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