require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.3.tgz"
  sha256 "0f70bf6e8b9ce458dc9889d7ac8cad938cbb685d43b90b2f7dd1fc868881a759"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e84e7a3afc5a18654f0ab9839030e4c1f143f2c6dec1a23353532655fe2eda34"
    sha256 cellar: :any,                 arm64_ventura:  "e84e7a3afc5a18654f0ab9839030e4c1f143f2c6dec1a23353532655fe2eda34"
    sha256 cellar: :any,                 arm64_monterey: "e84e7a3afc5a18654f0ab9839030e4c1f143f2c6dec1a23353532655fe2eda34"
    sha256 cellar: :any,                 sonoma:         "030d93deb042b7e0c124d5aa401e57d2b3d977d38c75b30f1cdbb71063e73f1c"
    sha256 cellar: :any,                 ventura:        "030d93deb042b7e0c124d5aa401e57d2b3d977d38c75b30f1cdbb71063e73f1c"
    sha256 cellar: :any,                 monterey:       "030d93deb042b7e0c124d5aa401e57d2b3d977d38c75b30f1cdbb71063e73f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2d99204d5b0c80ab41b1431546fe02b3f778575f2c97b764a6c4c32e7ea9950"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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