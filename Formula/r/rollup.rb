require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.1.tgz"
  sha256 "f7b7830ea4ebff9608ddd6558880c22370fcafe20bf46eaf7ec6d68ff3a277ea"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d456a7cf0f2f530f898d9220984d133e8dceb3c860867de7519926d1849e7d4e"
    sha256 cellar: :any,                 arm64_ventura:  "d456a7cf0f2f530f898d9220984d133e8dceb3c860867de7519926d1849e7d4e"
    sha256 cellar: :any,                 arm64_monterey: "d456a7cf0f2f530f898d9220984d133e8dceb3c860867de7519926d1849e7d4e"
    sha256 cellar: :any,                 sonoma:         "006e97f914c7cf7022608fd625e971329e577c3fd8a5cab19285cdd486cb3253"
    sha256 cellar: :any,                 ventura:        "006e97f914c7cf7022608fd625e971329e577c3fd8a5cab19285cdd486cb3253"
    sha256 cellar: :any,                 monterey:       "006e97f914c7cf7022608fd625e971329e577c3fd8a5cab19285cdd486cb3253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b459bff0d4cbbf6a4b4c8a4bdc3fe736a4be11b0854ff5fa64e8939ad9b3a94"
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