require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.26.2.tgz"
  sha256 "75667037744da7460ab1bc9b86b8c9f62bc8c3686185f4f040a7c98a8c67c544"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1188cc510d304dbb6fa08e605c3b2d3b4057845437f779059a704c7afe4a059f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1188cc510d304dbb6fa08e605c3b2d3b4057845437f779059a704c7afe4a059f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1188cc510d304dbb6fa08e605c3b2d3b4057845437f779059a704c7afe4a059f"
    sha256 cellar: :any_skip_relocation, ventura:        "71a486ae8e3622f6196965b0df6c60dc1b93c0bdbc6013dad3ab3f1568d0726e"
    sha256 cellar: :any_skip_relocation, monterey:       "71a486ae8e3622f6196965b0df6c60dc1b93c0bdbc6013dad3ab3f1568d0726e"
    sha256 cellar: :any_skip_relocation, big_sur:        "71a486ae8e3622f6196965b0df6c60dc1b93c0bdbc6013dad3ab3f1568d0726e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cca490a47edc04518001c8ecd7af30a1983a70d87492e8b3447030a21794ec7"
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