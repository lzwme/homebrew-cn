require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.0.tgz"
  sha256 "ddf1e8fec41abdba5dbfdac02157c991b4cd88f150dcad4f2d369735ee31e833"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "845976d69a1a1fb0e94935f8d48c1262bac3081afd5cab361b1c754154cda8de"
    sha256 cellar: :any,                 arm64_ventura:  "845976d69a1a1fb0e94935f8d48c1262bac3081afd5cab361b1c754154cda8de"
    sha256 cellar: :any,                 arm64_monterey: "845976d69a1a1fb0e94935f8d48c1262bac3081afd5cab361b1c754154cda8de"
    sha256 cellar: :any,                 sonoma:         "a2cead6e214301e5ab9b881730c7a3d23e685dcfc8e0e556555c23a36a4709ac"
    sha256 cellar: :any,                 ventura:        "a2cead6e214301e5ab9b881730c7a3d23e685dcfc8e0e556555c23a36a4709ac"
    sha256 cellar: :any,                 monterey:       "a2cead6e214301e5ab9b881730c7a3d23e685dcfc8e0e556555c23a36a4709ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25273e953e5601f6f629405074dd6eb80fb6e68599e9313c44312cab44b08062"
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