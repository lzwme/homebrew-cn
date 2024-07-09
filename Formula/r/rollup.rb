require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.18.1.tgz"
  sha256 "ca6e167277641dfddcf2312a751f9e9bf28f94acfca91f18cbee729599453f9d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b5b4115ba3caea7b8006ba271d8d24f7bc96fcded48de61da281b0fb348695f"
    sha256 cellar: :any,                 arm64_ventura:  "7b5b4115ba3caea7b8006ba271d8d24f7bc96fcded48de61da281b0fb348695f"
    sha256 cellar: :any,                 arm64_monterey: "7b5b4115ba3caea7b8006ba271d8d24f7bc96fcded48de61da281b0fb348695f"
    sha256 cellar: :any,                 sonoma:         "e799d2e3d662b4a798a7e8533a6ac7ce59aada58796185085d9682cd3bf09fed"
    sha256 cellar: :any,                 ventura:        "e799d2e3d662b4a798a7e8533a6ac7ce59aada58796185085d9682cd3bf09fed"
    sha256 cellar: :any,                 monterey:       "e799d2e3d662b4a798a7e8533a6ac7ce59aada58796185085d9682cd3bf09fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce20c76b42dad9a66649c3636d3bc5374ec397c52eb2d5d977888ff24b3e6f3"
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