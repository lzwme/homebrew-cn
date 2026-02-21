class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.58.0.tgz"
  sha256 "0c2f3544afd9400386fdf48867c81bc3835b012812c35078ba99dfca4270a064"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4261e92b4f85c50d0de67b6099c1da69a3c4c2c2458e1990e550fbbcb8ee463"
    sha256 cellar: :any,                 arm64_sequoia: "0189bb70278820bab874feba94e41f2ceb6d08868a0567db1113bb9f49fc8807"
    sha256 cellar: :any,                 arm64_sonoma:  "0189bb70278820bab874feba94e41f2ceb6d08868a0567db1113bb9f49fc8807"
    sha256 cellar: :any,                 sonoma:        "27e41954434fdde85c6a7f9d10711cc5484d3b985041d46180bd5e691ce5c8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b693c521ed4efafbb8816330993badab7b656e40888896065bb9aa53daeeaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e1ec8c195108d9955aafc63ea4970ea8065588fc2b40a0be4ecb8b22f86adb"
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