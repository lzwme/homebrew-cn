require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.16.2.tgz"
  sha256 "f7b850a34e13f89f60b6b18e671f7c3d14e6cccbd03dd35202215dd5f05d6b29"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f103dde4050d8326ca40e334f2a8abd3318bc3ceaaa770206023cf92673d15f"
    sha256 cellar: :any,                 arm64_ventura:  "3f103dde4050d8326ca40e334f2a8abd3318bc3ceaaa770206023cf92673d15f"
    sha256 cellar: :any,                 arm64_monterey: "3f103dde4050d8326ca40e334f2a8abd3318bc3ceaaa770206023cf92673d15f"
    sha256 cellar: :any,                 sonoma:         "803db70e20644ec1ec2deee24424480c5fb58917cd84b1c5db046c30b07f3a9e"
    sha256 cellar: :any,                 ventura:        "803db70e20644ec1ec2deee24424480c5fb58917cd84b1c5db046c30b07f3a9e"
    sha256 cellar: :any,                 monterey:       "803db70e20644ec1ec2deee24424480c5fb58917cd84b1c5db046c30b07f3a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca765782d0e6b05fcdf12eb4db9be8c714bf9761e2c78515e8bfdc5cc181ac6"
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