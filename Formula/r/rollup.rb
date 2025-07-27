class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.45.3.tgz"
  sha256 "5724ba417726190a286b5593bbd2e84798b1d5b9d778b3d07c81a8d29aa8df1c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ab1d44deb1cae12944090cecf952039fd80c5972027444d168816bd07dc8bba"
    sha256 cellar: :any,                 arm64_sonoma:  "4ab1d44deb1cae12944090cecf952039fd80c5972027444d168816bd07dc8bba"
    sha256 cellar: :any,                 arm64_ventura: "4ab1d44deb1cae12944090cecf952039fd80c5972027444d168816bd07dc8bba"
    sha256 cellar: :any,                 sonoma:        "8c7be9ca4fd21bd91ce4c250477f2436cafabcf63bb1c80212d5c2e5dd25c463"
    sha256 cellar: :any,                 ventura:       "8c7be9ca4fd21bd91ce4c250477f2436cafabcf63bb1c80212d5c2e5dd25c463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2431da29bfbcb64a55e2f6b6af2ab3d091bceb09241fc60d3703aed0c7f94a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c3b8bb6bc38f778f18ecccfb4f78668779e6d86ea51b9a21c6a017d6da556de"
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