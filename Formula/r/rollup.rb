require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.3.tgz"
  sha256 "186f2300a34b56918fd2d567aaf6c0005165f5b062e985b339f08a6946c8078b"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd7d56c5ab5188016edcda84aefd0927bc1c79a97b53c5fbfc130a1bca91d112"
    sha256 cellar: :any,                 arm64_ventura:  "dd7d56c5ab5188016edcda84aefd0927bc1c79a97b53c5fbfc130a1bca91d112"
    sha256 cellar: :any,                 arm64_monterey: "dd7d56c5ab5188016edcda84aefd0927bc1c79a97b53c5fbfc130a1bca91d112"
    sha256 cellar: :any,                 sonoma:         "88d39bf6bc2931999db78cdd4f1e0c4c7184872055c56e3f8081a8d61bbc8a25"
    sha256 cellar: :any,                 ventura:        "88d39bf6bc2931999db78cdd4f1e0c4c7184872055c56e3f8081a8d61bbc8a25"
    sha256 cellar: :any,                 monterey:       "88d39bf6bc2931999db78cdd4f1e0c4c7184872055c56e3f8081a8d61bbc8a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95c3e917043f0e4ead924def2a8a702e4586f2ea22e2e3a1741858868c34069"
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