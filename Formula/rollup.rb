require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.7.tgz"
  sha256 "08359c2d32a8cad3b4f2ae4885fb3596fa61efe6756efeaa52fc09222b89aa93"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33378ca43c93719112a3ccf3f290681b8610299b4128ada45ad5b6f8774aa425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33378ca43c93719112a3ccf3f290681b8610299b4128ada45ad5b6f8774aa425"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33378ca43c93719112a3ccf3f290681b8610299b4128ada45ad5b6f8774aa425"
    sha256 cellar: :any_skip_relocation, ventura:        "9f360418dd1f2b67a7f40b9010f57c9b6c39ea25354f06cbf8df4db4098ccf63"
    sha256 cellar: :any_skip_relocation, monterey:       "9f360418dd1f2b67a7f40b9010f57c9b6c39ea25354f06cbf8df4db4098ccf63"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f360418dd1f2b67a7f40b9010f57c9b6c39ea25354f06cbf8df4db4098ccf63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1055e883fcf14a223cdc88e757f35c54bf6c19fe8185f430c421a93fa3503abf"
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