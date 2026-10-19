class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.9.tgz"
  sha256 "505ed2d052837d1988cfc17cc44fad232e5b124b3df66e238b0f3ccaf0a70f66"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0f8f0a58410698ae7cdb88b5e6bd6b35cce13f81e09f8197124d5091fe8e9992"
    sha256 cellar: :any,                 arm64_tahoe:       "0f8f0a58410698ae7cdb88b5e6bd6b35cce13f81e09f8197124d5091fe8e9992"
    sha256 cellar: :any,                 arm64_sequoia:     "0f8f0a58410698ae7cdb88b5e6bd6b35cce13f81e09f8197124d5091fe8e9992"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de1317795442bb15d180b07b6cffdb199fa0d762e24ceeb271e01400d4b49b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dd7b75809f5089cb073e02dbddc42c1dbc67ad9414c2b48a05a1572e87b3e2ce"
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