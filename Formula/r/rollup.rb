require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.10.0.tgz"
  sha256 "7285bfda16f914e5fa87ae04b7ee04b724c2efdde5318582a68b7862cfa9b0a1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ceb2b87d4afdff37339d5c464843b01ed397fffd026c688706a4956ee79ff553"
    sha256 cellar: :any,                 arm64_ventura:  "ceb2b87d4afdff37339d5c464843b01ed397fffd026c688706a4956ee79ff553"
    sha256 cellar: :any,                 arm64_monterey: "ceb2b87d4afdff37339d5c464843b01ed397fffd026c688706a4956ee79ff553"
    sha256 cellar: :any,                 sonoma:         "f53b817be38f6a3d56f7c92063c2beae07e31b7d295ec0f6a94291c894ec84b5"
    sha256 cellar: :any,                 ventura:        "f53b817be38f6a3d56f7c92063c2beae07e31b7d295ec0f6a94291c894ec84b5"
    sha256 cellar: :any,                 monterey:       "f53b817be38f6a3d56f7c92063c2beae07e31b7d295ec0f6a94291c894ec84b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9d8f49411c6e67ebc99c2f5f29f86c71274d45438f65365553c4141f0c178c"
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