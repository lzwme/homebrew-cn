require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.14.0.tgz"
  sha256 "75b3e23a95be7eef3d80b731b8615d7cf9e60d29e8638fc663fca6aeb68525db"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f892c2b02a6e2df65e10ce7041b0bebfdd1875ae75e6b5aac7fbef5f1ddab130"
    sha256 cellar: :any,                 arm64_ventura:  "f892c2b02a6e2df65e10ce7041b0bebfdd1875ae75e6b5aac7fbef5f1ddab130"
    sha256 cellar: :any,                 arm64_monterey: "f892c2b02a6e2df65e10ce7041b0bebfdd1875ae75e6b5aac7fbef5f1ddab130"
    sha256 cellar: :any,                 sonoma:         "bc1e683f80ed243c92b39b7c108af7d6c4c8a202612ddc28ec8cca6b47774296"
    sha256 cellar: :any,                 ventura:        "bc1e683f80ed243c92b39b7c108af7d6c4c8a202612ddc28ec8cca6b47774296"
    sha256 cellar: :any,                 monterey:       "bc1e683f80ed243c92b39b7c108af7d6c4c8a202612ddc28ec8cca6b47774296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944ac8d69afc85038fef6477843f49ff3d23270a38cf3c6695b78590d746f2d8"
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