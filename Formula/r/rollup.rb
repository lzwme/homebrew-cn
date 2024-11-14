class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.26.0.tgz"
  sha256 "7a477fb2b1a4d3e6706ae777da51b0318a9b2f8511583cf957fc43eedff107e7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf6b73929ab4ed1180ba5cd09a7901756698dd4a344f02f9427b2f04b698fca2"
    sha256 cellar: :any,                 arm64_sonoma:  "bf6b73929ab4ed1180ba5cd09a7901756698dd4a344f02f9427b2f04b698fca2"
    sha256 cellar: :any,                 arm64_ventura: "bf6b73929ab4ed1180ba5cd09a7901756698dd4a344f02f9427b2f04b698fca2"
    sha256 cellar: :any,                 sonoma:        "46d727594d795cb55a941bf1dfbdb3d06810d7bcbae9fa34db92bb42af065183"
    sha256 cellar: :any,                 ventura:       "46d727594d795cb55a941bf1dfbdb3d06810d7bcbae9fa34db92bb42af065183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a30c57cc6bc46f5cdfa8094311429db2cdb8a12921ddf9fe0dcf8c782ee8576"
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