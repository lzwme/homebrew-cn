class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.42.0.tgz"
  sha256 "439a0d22f2e14d5c3fc496ba6af9dbb7514ebaaf52da8564fa51db79bf7e59df"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8fb47f29cab6cb064b1831fd381f663b9e3b7c11b833da0c5edfe4953f18cb63"
    sha256 cellar: :any,                 arm64_sonoma:  "8fb47f29cab6cb064b1831fd381f663b9e3b7c11b833da0c5edfe4953f18cb63"
    sha256 cellar: :any,                 arm64_ventura: "8fb47f29cab6cb064b1831fd381f663b9e3b7c11b833da0c5edfe4953f18cb63"
    sha256 cellar: :any,                 sonoma:        "8df3dbc35be3338bb3a85285e4d8a5ae9ae71deba6a75769964b25d897193210"
    sha256 cellar: :any,                 ventura:       "8df3dbc35be3338bb3a85285e4d8a5ae9ae71deba6a75769964b25d897193210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ed75dcbfc07400fd1602c2cd2171e25d6e24f9f84dfde4a5ce99b2bb913fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d95145d56512aa68187a384bd736581a0ee85ce88f4673c70b3077fe544e307d"
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