require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.3.tgz"
  sha256 "497c6c12297081501ffd60e7de0f1e862f332a7467f5d0bf189d93d28aa64dec"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9afdf31b27e164329e233cba6ccc11439180f2dc852b0cd2accee3eb0e15c50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9afdf31b27e164329e233cba6ccc11439180f2dc852b0cd2accee3eb0e15c50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9afdf31b27e164329e233cba6ccc11439180f2dc852b0cd2accee3eb0e15c50"
    sha256 cellar: :any_skip_relocation, ventura:        "9b3e4ea583f0e91a0c84edeec1363249e784eacdb2c8916e2ccfaf66b481705f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b3e4ea583f0e91a0c84edeec1363249e784eacdb2c8916e2ccfaf66b481705f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b3e4ea583f0e91a0c84edeec1363249e784eacdb2c8916e2ccfaf66b481705f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375d4be0802bd6b1e2446b8171000139d6b0671d329b23b180497f6705782635"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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