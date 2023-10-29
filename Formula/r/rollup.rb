require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.5.tgz"
  sha256 "09a469a572959e32f68fa6f53a08f943c0eece79fd3fd3923500454ba76b49fd"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7673131c85a6a59535e3a86dbd0edbe4df1956ce0092b8f162b1ec2ddb25f43a"
    sha256 cellar: :any,                 arm64_ventura:  "7673131c85a6a59535e3a86dbd0edbe4df1956ce0092b8f162b1ec2ddb25f43a"
    sha256 cellar: :any,                 arm64_monterey: "7673131c85a6a59535e3a86dbd0edbe4df1956ce0092b8f162b1ec2ddb25f43a"
    sha256 cellar: :any,                 sonoma:         "718dab2ece546211875b24fded8787f1ac6333222266674873235900ab9ad76c"
    sha256 cellar: :any,                 ventura:        "718dab2ece546211875b24fded8787f1ac6333222266674873235900ab9ad76c"
    sha256 cellar: :any,                 monterey:       "718dab2ece546211875b24fded8787f1ac6333222266674873235900ab9ad76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53caa38f18f3cb4d4e3c0e9137c5fdde433933c13996189e9ddf97fb05fe7645"
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