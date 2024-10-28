class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.24.2.tgz"
  sha256 "2694fa935243c15886932521280e9360e282cbcca37613fcb02d8d44f1f9bdc0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ebc729ece44235870aeaf70f0bffc540e697587daeb71f9adedb1d92888dbfab"
    sha256 cellar: :any,                 arm64_sonoma:  "ebc729ece44235870aeaf70f0bffc540e697587daeb71f9adedb1d92888dbfab"
    sha256 cellar: :any,                 arm64_ventura: "ebc729ece44235870aeaf70f0bffc540e697587daeb71f9adedb1d92888dbfab"
    sha256 cellar: :any,                 sonoma:        "4f4b2cce56e63f094ab22d69d0382ac84837a5965e280ed64ba69a836de7efd1"
    sha256 cellar: :any,                 ventura:       "4f4b2cce56e63f094ab22d69d0382ac84837a5965e280ed64ba69a836de7efd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b6fff31c00f0a92c0648f1880fb35cc8b04c975ae46861b810f2e7a53821f3"
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