require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.5.1.tgz"
  sha256 "ed2adbaef1f5b64d9919842163055713ef7a435a4788ef74b54c680fd4c8636f"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f8963005acd74598374d536b159935a7d3897249b6fc9f61cb78bd0a0b050f9"
    sha256 cellar: :any,                 arm64_ventura:  "0f8963005acd74598374d536b159935a7d3897249b6fc9f61cb78bd0a0b050f9"
    sha256 cellar: :any,                 arm64_monterey: "0f8963005acd74598374d536b159935a7d3897249b6fc9f61cb78bd0a0b050f9"
    sha256 cellar: :any,                 sonoma:         "96ea4e80ab45c1407858f08e7d7033a04319cb51784b8a89d9077d3e66028a0e"
    sha256 cellar: :any,                 ventura:        "96ea4e80ab45c1407858f08e7d7033a04319cb51784b8a89d9077d3e66028a0e"
    sha256 cellar: :any,                 monterey:       "96ea4e80ab45c1407858f08e7d7033a04319cb51784b8a89d9077d3e66028a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdb0763db86439acf5d7c8356184a6059b23cbfc46cb1938dfb7f40a3197e29f"
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