require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.29.0.tgz"
  sha256 "744630da636662d87d401969567f64f51cd52659b3d99509b5d6ded3a50f7948"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb14c4fd24539b789491f5b947a6f389bd9b126f08e4e2ee9c92a9fa7075067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb14c4fd24539b789491f5b947a6f389bd9b126f08e4e2ee9c92a9fa7075067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eb14c4fd24539b789491f5b947a6f389bd9b126f08e4e2ee9c92a9fa7075067"
    sha256 cellar: :any_skip_relocation, ventura:        "bbd18088d1949750e4faed8735496fd1a7d2a04c9d9ce44b40072206ce134951"
    sha256 cellar: :any_skip_relocation, monterey:       "bbd18088d1949750e4faed8735496fd1a7d2a04c9d9ce44b40072206ce134951"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbd18088d1949750e4faed8735496fd1a7d2a04c9d9ce44b40072206ce134951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d880ca690e034c81f15551ca008b589a6e88cea499349250ea8e499cb903406"
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