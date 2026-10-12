class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.5.tgz"
  sha256 "542ebe985a7dd997c0a6fabc428b860180192797fad47374ccb57a443f26c6b3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "591a751afae48628070caaa545a532c908f437a6868724bc895259762e7155e1"
    sha256 cellar: :any,                 arm64_tahoe:       "591a751afae48628070caaa545a532c908f437a6868724bc895259762e7155e1"
    sha256 cellar: :any,                 arm64_sequoia:     "591a751afae48628070caaa545a532c908f437a6868724bc895259762e7155e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ecc33d4bd2603a103585e833f2ed9994505f69ad618c68d75191ee50ac1ca76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ba61af972f0d224a391a1b37e6dd4e6786d7e10a5ec6a36c53f787318beb4587"
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