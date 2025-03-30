class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.38.0.tgz"
  sha256 "391e739bbcaccbaa07239c69500675dd0534c0ee436f7849df4dddcdfef76083"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e2562a0f7bb3413f5a715be37dcd48a605bc81af4de16bf99295807113151e5"
    sha256 cellar: :any,                 arm64_sonoma:  "9e2562a0f7bb3413f5a715be37dcd48a605bc81af4de16bf99295807113151e5"
    sha256 cellar: :any,                 arm64_ventura: "9e2562a0f7bb3413f5a715be37dcd48a605bc81af4de16bf99295807113151e5"
    sha256 cellar: :any,                 sonoma:        "18fdc2a0e40db7d301e2fbc79c7d354fed07599de25dc4343e29e7fd020f556e"
    sha256 cellar: :any,                 ventura:       "18fdc2a0e40db7d301e2fbc79c7d354fed07599de25dc4343e29e7fd020f556e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8e9560d470b9e06999bd6e985f00015b0ed30839ed82be464bd911a4879783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9bd0ef4bde9b379237373f7cc3798ef21203782dec0fc5b50fc8d5610a27dd4"
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