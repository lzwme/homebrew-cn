require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.3.1.tgz"
  sha256 "cc99676b664db63d74d435edc7fdb0f9b5f4840ccc70f00c5905f9e3bd9680e6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26742d97c26d8dc1b07e44b19693fe59c3ddc6a25ec0cbc3b41b8f1adb1a7f45"
    sha256 cellar: :any,                 arm64_ventura:  "26742d97c26d8dc1b07e44b19693fe59c3ddc6a25ec0cbc3b41b8f1adb1a7f45"
    sha256 cellar: :any,                 arm64_monterey: "26742d97c26d8dc1b07e44b19693fe59c3ddc6a25ec0cbc3b41b8f1adb1a7f45"
    sha256 cellar: :any,                 sonoma:         "41626cea1822c861c5b2aaeb36c0f4ceb4a6cfff9fa63b846a8de7f1df0a01a6"
    sha256 cellar: :any,                 ventura:        "41626cea1822c861c5b2aaeb36c0f4ceb4a6cfff9fa63b846a8de7f1df0a01a6"
    sha256 cellar: :any,                 monterey:       "41626cea1822c861c5b2aaeb36c0f4ceb4a6cfff9fa63b846a8de7f1df0a01a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4542db35c5f62c4d67ad624b8248b7a6c743c21671ee1c95f9c9b2a64701cff4"
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