require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.23.0.tgz"
  sha256 "5e10c97444e861167ca993a2d7e16115e15c30b0bf869887b40e4c35ccd506f9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c277445423d982a7c13a8b13f7866d12875d6e148107cfc30e67851978f57ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c277445423d982a7c13a8b13f7866d12875d6e148107cfc30e67851978f57ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c277445423d982a7c13a8b13f7866d12875d6e148107cfc30e67851978f57ca"
    sha256 cellar: :any_skip_relocation, ventura:        "5810352fe4668d7a421b17e22f131787eda2178c282cbb3344db83065089ab17"
    sha256 cellar: :any_skip_relocation, monterey:       "5810352fe4668d7a421b17e22f131787eda2178c282cbb3344db83065089ab17"
    sha256 cellar: :any_skip_relocation, big_sur:        "5810352fe4668d7a421b17e22f131787eda2178c282cbb3344db83065089ab17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c404140e322fe7cb9d57cc83783c9a4ed98445c6f20bc4071b5a55c10bcbf8"
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