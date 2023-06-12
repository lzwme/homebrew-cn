require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.25.0.tgz"
  sha256 "0c6be3d673d15ce11863e6fb76fd7b94fbfb3783ce892ec6d7590bf5ac99d7e1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "711b31dd06657ad40a3fcce44d70542c0f6e69c96d2536a5628e95a4f2d16606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "711b31dd06657ad40a3fcce44d70542c0f6e69c96d2536a5628e95a4f2d16606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "711b31dd06657ad40a3fcce44d70542c0f6e69c96d2536a5628e95a4f2d16606"
    sha256 cellar: :any_skip_relocation, ventura:        "5b3492f93dba680e98366bb2cfce70dae7b40e262e896663c0424d98c6b7b2d0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b3492f93dba680e98366bb2cfce70dae7b40e262e896663c0424d98c6b7b2d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b3492f93dba680e98366bb2cfce70dae7b40e262e896663c0424d98c6b7b2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e5c90b9cbb6e7f127691b0ca0c0e67ca09c8a2061b11ef15d5a421d9360de8"
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