class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.46.3.tgz"
  sha256 "db16c6e474bd3ee15167bbd7930fef3e6e1901dac2eba78a18a2ad023a697122"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57b9d8a95262753008fab7f7503358d2aaecf507f65a9f0c146a0484c019c75e"
    sha256 cellar: :any,                 arm64_sonoma:  "57b9d8a95262753008fab7f7503358d2aaecf507f65a9f0c146a0484c019c75e"
    sha256 cellar: :any,                 arm64_ventura: "57b9d8a95262753008fab7f7503358d2aaecf507f65a9f0c146a0484c019c75e"
    sha256 cellar: :any,                 sonoma:        "90a0d3cc80f8099f49eb110a5efe5ffd0105ecadae3ec27952d069d9a41f7507"
    sha256 cellar: :any,                 ventura:       "90a0d3cc80f8099f49eb110a5efe5ffd0105ecadae3ec27952d069d9a41f7507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db69b1673afdb2f6904625ced54e177f1b3fbc08bc9286f8a51ff5fdb11a2185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a5b5606a810f278af59ee52b9ffef9ddc09cdef7a607b20f2dac92da8f2f8a1"
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