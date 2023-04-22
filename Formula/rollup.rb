require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.7.tgz"
  sha256 "babdfff58b4ae0d19e658557e4ab6916ca7d3a17ab8b92194f7980ee8b35c57c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "763744c1ed941723d14e0807e9efcdf61c1464cb2a16ab2b57f32ddf405b3342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "763744c1ed941723d14e0807e9efcdf61c1464cb2a16ab2b57f32ddf405b3342"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "763744c1ed941723d14e0807e9efcdf61c1464cb2a16ab2b57f32ddf405b3342"
    sha256 cellar: :any_skip_relocation, ventura:        "4b4db76d558d3784e57a0146464d0641f6f10a4adb2b601b76d5dc8f192283f0"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4db76d558d3784e57a0146464d0641f6f10a4adb2b601b76d5dc8f192283f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b4db76d558d3784e57a0146464d0641f6f10a4adb2b601b76d5dc8f192283f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a209aff2163e58286c411ca3b20c67d82619c38a9c019ca005ff485fb5bb8db"
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