require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.4.tgz"
  sha256 "51aca190d23769f0fd85644bdee1beb3c46038c3a6dbc6a8e3647098b778d8ee"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5343612e79827c93c8e34a262ef5da738fe3e332a4d1ca8918a325ff87f2cf23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5343612e79827c93c8e34a262ef5da738fe3e332a4d1ca8918a325ff87f2cf23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5343612e79827c93c8e34a262ef5da738fe3e332a4d1ca8918a325ff87f2cf23"
    sha256 cellar: :any_skip_relocation, ventura:        "6b55b15dd5ec8cd968c95574846bbd1c22cb68b4569381d7779a83865b4b8b02"
    sha256 cellar: :any_skip_relocation, monterey:       "6b55b15dd5ec8cd968c95574846bbd1c22cb68b4569381d7779a83865b4b8b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b55b15dd5ec8cd968c95574846bbd1c22cb68b4569381d7779a83865b4b8b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da17c90f5c41835af0c17409082ac875d335c3e6a7913d2289a8e923a4af22fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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