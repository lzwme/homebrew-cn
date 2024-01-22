require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.6.tgz"
  sha256 "77930be06f92d126a2b25bb96d8ffe5cd9460f0e640e0af7e297fa9ad095cf07"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b218c3635c3da453717248d4432e612db00e671ad57e855773961ec51a57e9e"
    sha256 cellar: :any,                 arm64_ventura:  "5b218c3635c3da453717248d4432e612db00e671ad57e855773961ec51a57e9e"
    sha256 cellar: :any,                 arm64_monterey: "5b218c3635c3da453717248d4432e612db00e671ad57e855773961ec51a57e9e"
    sha256 cellar: :any,                 sonoma:         "57fba25ffa07786926e1201f98f118a61c2c9c847426f1ba6e44364f51c8f66e"
    sha256 cellar: :any,                 ventura:        "57fba25ffa07786926e1201f98f118a61c2c9c847426f1ba6e44364f51c8f66e"
    sha256 cellar: :any,                 monterey:       "57fba25ffa07786926e1201f98f118a61c2c9c847426f1ba6e44364f51c8f66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5feaaf1a9a25c32fdb7e5ba9a14f925e9d353da882efd2a24f2049352875bb34"
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