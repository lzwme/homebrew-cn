class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.23.0.tgz"
  sha256 "27a614727dd07d8393b340cbac2ebcf96af976a3104137ff639a032036c20015"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef42d6b230b6563ce7ca30e9a2b616d528ab1be22ff01dfd59a99233c55eebc5"
    sha256 cellar: :any,                 arm64_sonoma:  "ef42d6b230b6563ce7ca30e9a2b616d528ab1be22ff01dfd59a99233c55eebc5"
    sha256 cellar: :any,                 arm64_ventura: "ef42d6b230b6563ce7ca30e9a2b616d528ab1be22ff01dfd59a99233c55eebc5"
    sha256 cellar: :any,                 sonoma:        "cdae1d627a67a18f7a8de9138c46d206d9f5512040a50b1e3226162771d9d9e1"
    sha256 cellar: :any,                 ventura:       "cdae1d627a67a18f7a8de9138c46d206d9f5512040a50b1e3226162771d9d9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2249d33fc727f9c014674c8d92803b8a481df51d7a91cadfada068139bc4c4"
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