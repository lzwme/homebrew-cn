require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.4.1.tgz"
  sha256 "f5182bf0ff1bd1d2304aa6cd6002ab10fa7ec77af6b68181645f1ed51bccb6c3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53df9068f0710f65804db86b58b1dd8b3463777c248e464fa21c686b7fcdf2ea"
    sha256 cellar: :any,                 arm64_ventura:  "53df9068f0710f65804db86b58b1dd8b3463777c248e464fa21c686b7fcdf2ea"
    sha256 cellar: :any,                 arm64_monterey: "53df9068f0710f65804db86b58b1dd8b3463777c248e464fa21c686b7fcdf2ea"
    sha256 cellar: :any,                 sonoma:         "ce15009392d147d611d49985ad355516964601bbef10643109730d6787e2cac3"
    sha256 cellar: :any,                 ventura:        "ce15009392d147d611d49985ad355516964601bbef10643109730d6787e2cac3"
    sha256 cellar: :any,                 monterey:       "ce15009392d147d611d49985ad355516964601bbef10643109730d6787e2cac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c03b7fb5c32170de8ac8ad3ad76e168ece3e27f7e0c81cee4ca5c3d063ab22"
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