class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.54.0.tgz"
  sha256 "044ac2322594e4e2bdcdfd0cb55d5279e2fc20924a8332938628eab1144763f9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91850022e6369d19e3c3d1886243a57f63e72f2d5316a80b685f50d7b442bf34"
    sha256 cellar: :any,                 arm64_sequoia: "c50ccc5cb56305061633bd37d8343175037d3ec5afe83da136378b7281e7e9de"
    sha256 cellar: :any,                 arm64_sonoma:  "c50ccc5cb56305061633bd37d8343175037d3ec5afe83da136378b7281e7e9de"
    sha256 cellar: :any,                 sonoma:        "d73a97ed899a9f4f0bfee88da283b25bbf096e2586c332cc00ad1743468e0b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f87324efc345eb7d4e2983f555444a83216ef2672439b6c913ff8fe1102e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640dad33c84d0895c3791bd6b98b8a9098e738e3ca9e912d36a8e2588fe8281b"
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