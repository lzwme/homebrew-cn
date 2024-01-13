require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.5.tgz"
  sha256 "ce1c5bf6223f5c9c852993cc6834e642d335e409ca147f70309705c8b4f33034"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66ec3a7af24a71b435b36f79415c43087f5cbd6b793a95c67dd798839fa6ecbb"
    sha256 cellar: :any,                 arm64_ventura:  "66ec3a7af24a71b435b36f79415c43087f5cbd6b793a95c67dd798839fa6ecbb"
    sha256 cellar: :any,                 arm64_monterey: "66ec3a7af24a71b435b36f79415c43087f5cbd6b793a95c67dd798839fa6ecbb"
    sha256 cellar: :any,                 sonoma:         "57dbc3694ab7c32c9210f36476f7286dd94a06ff4e58e363e7aee09c90288634"
    sha256 cellar: :any,                 ventura:        "57dbc3694ab7c32c9210f36476f7286dd94a06ff4e58e363e7aee09c90288634"
    sha256 cellar: :any,                 monterey:       "57dbc3694ab7c32c9210f36476f7286dd94a06ff4e58e363e7aee09c90288634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f82bb8cdb7ab92a3c4156f284ee2230f4624f5aaa3927cf1982a53a1f30532"
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