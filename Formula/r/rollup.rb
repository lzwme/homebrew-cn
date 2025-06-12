class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.43.0.tgz"
  sha256 "6ffc5484b3201f57d5b115dab5d9df0cfa271b1a35493d0811f2dda6a9448887"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efa8434fafe110b300c7d71bcebda4414127d82600800fa59ecb980f5793a205"
    sha256 cellar: :any,                 arm64_sonoma:  "efa8434fafe110b300c7d71bcebda4414127d82600800fa59ecb980f5793a205"
    sha256 cellar: :any,                 arm64_ventura: "efa8434fafe110b300c7d71bcebda4414127d82600800fa59ecb980f5793a205"
    sha256 cellar: :any,                 sonoma:        "5d89de859007f9b48d2cf94f353c4c22938755c4acd46a4fbc49417311e31885"
    sha256 cellar: :any,                 ventura:       "5d89de859007f9b48d2cf94f353c4c22938755c4acd46a4fbc49417311e31885"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb2abc524f53ae010e9cde39e981302d397de6f526d1f0c56f63dd3d4e0a03dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "131e97256d0e8882072742e7884bc760f71855ba56f242e7fed75feca7e98217"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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