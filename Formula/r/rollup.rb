class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.53.4.tgz"
  sha256 "7ea2ce4ca2b294e86fd8c8e034e0c83dd8483dbc546540c87f1235587c9cf017"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5dbc38bc0fc74261da71a7abe383784edfaa7a4794de7747814e6ac34ac8f5f0"
    sha256 cellar: :any,                 arm64_sequoia: "ee48405b740c1754c4c87e89bc3a6fc952c5326b9bd9aa1f156d029fc9c42ad1"
    sha256 cellar: :any,                 arm64_sonoma:  "ee48405b740c1754c4c87e89bc3a6fc952c5326b9bd9aa1f156d029fc9c42ad1"
    sha256 cellar: :any,                 sonoma:        "bc733ea5923a0622302b3bb50dd24a2269cd052ad037b344e6b5493ea89644bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "280f9cec8dc6cbec1775120faa0a8fae37487c66aff77bae1a831fdcd8b2262e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60dc9d2ee55c67370999c6f7f06abce139ded1c902627e3d839efaa3b72a3ef4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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