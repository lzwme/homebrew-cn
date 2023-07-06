require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.26.1.tgz"
  sha256 "c228e4eebb6188d9974c6ad65604292201cac9b5efdeb96b59049bc80891fe3d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7767de2dd0b1cfca4c6f1552187ee066686bed8162afab840b2719728979e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7767de2dd0b1cfca4c6f1552187ee066686bed8162afab840b2719728979e35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7767de2dd0b1cfca4c6f1552187ee066686bed8162afab840b2719728979e35"
    sha256 cellar: :any_skip_relocation, ventura:        "650942315d0c2bec2a6d4a9e51bcbbaa5d69374ac6e32fa57815aeb1e6ee84b8"
    sha256 cellar: :any_skip_relocation, monterey:       "650942315d0c2bec2a6d4a9e51bcbbaa5d69374ac6e32fa57815aeb1e6ee84b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "650942315d0c2bec2a6d4a9e51bcbbaa5d69374ac6e32fa57815aeb1e6ee84b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a104d0c533931334cac725249da878398624a15d33948aef454371a216ec6fe0"
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