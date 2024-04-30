require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.17.1.tgz"
  sha256 "9e96e92dc7063458004b94c010ea976cb78f97aa3e0faf0aae3bc2efc8192100"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "996e2d3be01270ad7245db793be3540e3f792b7a8baffb2725dc9db71127fdc8"
    sha256 cellar: :any,                 arm64_ventura:  "996e2d3be01270ad7245db793be3540e3f792b7a8baffb2725dc9db71127fdc8"
    sha256 cellar: :any,                 arm64_monterey: "996e2d3be01270ad7245db793be3540e3f792b7a8baffb2725dc9db71127fdc8"
    sha256 cellar: :any,                 sonoma:         "db23293a345426a1cfa18e88527b271a1faf589f58df60527d1cce325bd84363"
    sha256 cellar: :any,                 ventura:        "db23293a345426a1cfa18e88527b271a1faf589f58df60527d1cce325bd84363"
    sha256 cellar: :any,                 monterey:       "db23293a345426a1cfa18e88527b271a1faf589f58df60527d1cce325bd84363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e183163acd79fd216b0dde9b41caa0d19cea96d65577d5be86b0074038b20d5"
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