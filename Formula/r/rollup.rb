class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.27.4.tgz"
  sha256 "3fffae23a91d75bed4ec61ae6880c1f82170bc5794ef51e0ae282aeeb4171afb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b5b87ed327141c6367e089595c5383a0f5f9393ba19c1fc45d7a3b8c34fbe46"
    sha256 cellar: :any,                 arm64_sonoma:  "8b5b87ed327141c6367e089595c5383a0f5f9393ba19c1fc45d7a3b8c34fbe46"
    sha256 cellar: :any,                 arm64_ventura: "8b5b87ed327141c6367e089595c5383a0f5f9393ba19c1fc45d7a3b8c34fbe46"
    sha256 cellar: :any,                 sonoma:        "7c199a6da89d437f6fea6dc4644da19fe87ef776c2a5eabe7bbc77ebaf25e9db"
    sha256 cellar: :any,                 ventura:       "7c199a6da89d437f6fea6dc4644da19fe87ef776c2a5eabe7bbc77ebaf25e9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8952bc95afc57c3191cfebef9786eb0eb77fa7cca87ea99749f629cafb914681"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
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