require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.19.0.tgz"
  sha256 "785c7cf2997e0b74c7232650202d8d5e9d3d71968b7ef05fcc100398a1d784fd"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6109898b167e14ab43efa883655cbee7adcbe8206916ce4d51b05ff1d006b001"
    sha256 cellar: :any,                 arm64_ventura:  "6109898b167e14ab43efa883655cbee7adcbe8206916ce4d51b05ff1d006b001"
    sha256 cellar: :any,                 arm64_monterey: "6109898b167e14ab43efa883655cbee7adcbe8206916ce4d51b05ff1d006b001"
    sha256 cellar: :any,                 sonoma:         "cf5959fe47c3bda3938133ad69a6b694d013366b599aa423cd97f03aa01bade7"
    sha256 cellar: :any,                 ventura:        "cf5959fe47c3bda3938133ad69a6b694d013366b599aa423cd97f03aa01bade7"
    sha256 cellar: :any,                 monterey:       "cf5959fe47c3bda3938133ad69a6b694d013366b599aa423cd97f03aa01bade7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fdd9a0b766919172a08ddf7a4c41fac7d1bcddcafeb3a52645bc93a1fdc922f"
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