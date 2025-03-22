class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.36.0.tgz"
  sha256 "2de7a3988500148e53438374a72f599b56cda26bb0d721a76d5b777aeb6014d0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6fbebf72ce13ebe4656bf28806d705fc017b3f0c5b0d51a9454bbabe76e5f163"
    sha256 cellar: :any,                 arm64_sonoma:  "6fbebf72ce13ebe4656bf28806d705fc017b3f0c5b0d51a9454bbabe76e5f163"
    sha256 cellar: :any,                 arm64_ventura: "6fbebf72ce13ebe4656bf28806d705fc017b3f0c5b0d51a9454bbabe76e5f163"
    sha256 cellar: :any,                 sonoma:        "76cfe41af0f1cdf1f59b6b3b0d48a77aaf2416744085d72a996d3a01cb838aab"
    sha256 cellar: :any,                 ventura:       "76cfe41af0f1cdf1f59b6b3b0d48a77aaf2416744085d72a996d3a01cb838aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b4aaeea27ad97964ecf9a08c71d1814ca1c85a9ba60bc7aa1ad358c61979fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af8448c4df1c08eab43cd11c952a42e2c80ab782603e721606f962096ebd9cf0"
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