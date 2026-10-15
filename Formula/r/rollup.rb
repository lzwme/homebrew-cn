class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.6.tgz"
  sha256 "85b859609fb6e48c50edc8f83c70efc60dc329b76e38e69eb5c245bd2160f272"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "13e913b099749449fea69de62291afe1e87dba03a82bedfd29f19b113c3a10f1"
    sha256 cellar: :any,                 arm64_tahoe:       "13e913b099749449fea69de62291afe1e87dba03a82bedfd29f19b113c3a10f1"
    sha256 cellar: :any,                 arm64_sequoia:     "13e913b099749449fea69de62291afe1e87dba03a82bedfd29f19b113c3a10f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "596b07fca6ec9e9bcf8c59da8638fdabe0535d1277c709784655fffbf978b356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3ebad49ebbb6554a19d39cd313667acc899c646807375261dfb659cea58709f3"
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