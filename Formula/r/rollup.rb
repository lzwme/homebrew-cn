class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.61.0.tgz"
  sha256 "bd61749d50454a68d292409af1cd909a73ef8e486bf47b8df8670a1750f21300"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9152b80cc0e3b2528d844f614900c84e734fc73949336e70de7c28c8a7b4e240"
    sha256 cellar: :any,                 arm64_sequoia: "d0a1a9f91b78a08abc82cf88290aaa9e9462ceca69e267c77d6fcf15be17a7fa"
    sha256 cellar: :any,                 arm64_sonoma:  "d0a1a9f91b78a08abc82cf88290aaa9e9462ceca69e267c77d6fcf15be17a7fa"
    sha256 cellar: :any,                 sonoma:        "10b1138c22756716f10e90fab3af2b4e229d3c8b4f91a213ca3309b81b6dc24b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca42f094bbb74a55f74f4637aeba6799613f66d08fbe3fbf1613b12f9b67d980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe43268ba0fcfe2cd2c9ccdc67b894af0daf90d9e28200eb2163714aa26aab92"
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