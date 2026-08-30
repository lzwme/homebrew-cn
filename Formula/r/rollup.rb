class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.1.tgz"
  sha256 "88b9180834f6d0472f49d379e13cb8d5d909eab28a34a4c766ec1676502e8f78"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70a5bdbdcd075320eb25d4eae8039ef50707a8e37e7084cba40b0109847ec4ae"
    sha256 cellar: :any,                 arm64_sequoia: "70a5bdbdcd075320eb25d4eae8039ef50707a8e37e7084cba40b0109847ec4ae"
    sha256 cellar: :any,                 arm64_sonoma:  "70a5bdbdcd075320eb25d4eae8039ef50707a8e37e7084cba40b0109847ec4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a0f1be30485c1054e26cbea75f51eecdefaa10520513c4bba891081bcd137a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca9c05dd281a3b6186de87b167f728177668439f7f6a1d2b36721a6871a9891"
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