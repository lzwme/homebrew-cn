class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.22.5.tgz"
  sha256 "a6bb089be5e5abe35da1a9c4c3bd54fcea7db4a2e9a3c243e68ef8056f7bfc04"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efb45a7f8572a45c636f5da14959c88af0cfe43c81a836d97b41e57ca8e22484"
    sha256 cellar: :any,                 arm64_sonoma:  "efb45a7f8572a45c636f5da14959c88af0cfe43c81a836d97b41e57ca8e22484"
    sha256 cellar: :any,                 arm64_ventura: "efb45a7f8572a45c636f5da14959c88af0cfe43c81a836d97b41e57ca8e22484"
    sha256 cellar: :any,                 sonoma:        "3f78e58718d8ececec562629cd22163ea54a86dddf9d2912495847211ccb5657"
    sha256 cellar: :any,                 ventura:       "3f78e58718d8ececec562629cd22163ea54a86dddf9d2912495847211ccb5657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bc33b6ead4bc79f027b4dd58d01bf52918858d52c46ec39c27049ef0d2a1e8"
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