class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.0.tgz"
  sha256 "b74f9bd6010a0887f05796457b13346178d8574106158cbf66bdf8e37d45fd39"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ae4a69bd6df2d598a668d9fc1d57d1a8e292869bf53de952786bad72eb493899"
    sha256 cellar: :any,                 arm64_tahoe:       "ae4a69bd6df2d598a668d9fc1d57d1a8e292869bf53de952786bad72eb493899"
    sha256 cellar: :any,                 arm64_sequoia:     "ae4a69bd6df2d598a668d9fc1d57d1a8e292869bf53de952786bad72eb493899"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df02d7c613c6f060a5aeaeb771a120e627202c8352098395aab09a2889169e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fad2a3eef919e12c8aa8f4e864865380700d07230c736c189b906a0a8a3f8e1d"
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