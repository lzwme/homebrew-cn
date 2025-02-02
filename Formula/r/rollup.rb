class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.0.tgz"
  sha256 "384199007a6aeaf57531af6ee4c8c3b31090a5301e83e546f272fab709ae7eeb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57e7893a1f5fae2ec6b7cd46ebdbeb5234214d552b25a645a01dce775c4e1941"
    sha256 cellar: :any,                 arm64_sonoma:  "57e7893a1f5fae2ec6b7cd46ebdbeb5234214d552b25a645a01dce775c4e1941"
    sha256 cellar: :any,                 arm64_ventura: "57e7893a1f5fae2ec6b7cd46ebdbeb5234214d552b25a645a01dce775c4e1941"
    sha256 cellar: :any,                 sonoma:        "8c156ba1da45e3fc7701620d822144c58d0a66c14da7b1adad53529118046576"
    sha256 cellar: :any,                 ventura:       "8c156ba1da45e3fc7701620d822144c58d0a66c14da7b1adad53529118046576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01096a9434201dbaaafa8ecfc4d10af5051245d0f3da7663e99f35936e0131f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end