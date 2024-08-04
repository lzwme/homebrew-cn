class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.20.0.tgz"
  sha256 "0b950d367d25d1b6393bfb1d807c9bad476137df810bbe55d5e279557997c1f7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0dfdd6f00dc8c4d3c06f1f6a065145d44ede9504316883737eaf19fb9a1600a2"
    sha256 cellar: :any,                 arm64_ventura:  "0dfdd6f00dc8c4d3c06f1f6a065145d44ede9504316883737eaf19fb9a1600a2"
    sha256 cellar: :any,                 arm64_monterey: "0dfdd6f00dc8c4d3c06f1f6a065145d44ede9504316883737eaf19fb9a1600a2"
    sha256 cellar: :any,                 sonoma:         "1411dc7ef8edbf74498842c06c90dfea800aa92cea0b861fc08ce915e67a3be8"
    sha256 cellar: :any,                 ventura:        "1411dc7ef8edbf74498842c06c90dfea800aa92cea0b861fc08ce915e67a3be8"
    sha256 cellar: :any,                 monterey:       "1411dc7ef8edbf74498842c06c90dfea800aa92cea0b861fc08ce915e67a3be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabd992c1444d6e9ce237b50fb1379a816473cd7e594b580403b1536e2a57fb5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end