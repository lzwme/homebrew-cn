require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.3.tgz"
  sha256 "ad89f17b97ed52392c0ca4f0fa56274bf5882509d640f68fc4c5419a950b1dba"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6611d0d672be3ad75d18fc29bea1a5aeb25025aa2090b9354faa61cf27e6ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c6611d0d672be3ad75d18fc29bea1a5aeb25025aa2090b9354faa61cf27e6ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c6611d0d672be3ad75d18fc29bea1a5aeb25025aa2090b9354faa61cf27e6ee"
    sha256 cellar: :any_skip_relocation, ventura:        "6e3b555265f9d5140b8f9012b471cc5c6124f7487d3c2a276f8e746b13179b06"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3b555265f9d5140b8f9012b471cc5c6124f7487d3c2a276f8e746b13179b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e3b555265f9d5140b8f9012b471cc5c6124f7487d3c2a276f8e746b13179b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9728fb5dc2b2957ea7224dfd0481d2f74a6722ed281204b264ed3fffeefe645d"
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