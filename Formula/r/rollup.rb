class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.3.tgz"
  sha256 "c9d339808a70da0d0728150e26d6b0ed736e08c6d95757a0c6bcc704278ad8f6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5a8fc8fb761ee279a7e0e13c6f6bd3052c9513c72ae4b54e9b628d0df231fd3a"
    sha256 cellar: :any,                 arm64_tahoe:       "5a8fc8fb761ee279a7e0e13c6f6bd3052c9513c72ae4b54e9b628d0df231fd3a"
    sha256 cellar: :any,                 arm64_sequoia:     "5a8fc8fb761ee279a7e0e13c6f6bd3052c9513c72ae4b54e9b628d0df231fd3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "928906f8862db60e37cf560ca077c1d00b59d7fc2d3dbdbdaf5a1023e0757749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "79488324237e3f04b8ace7469c223b051375db3369acaaff02502573dcc6e36b"
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