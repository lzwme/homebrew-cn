require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.14.1.tgz"
  sha256 "8494ac99725439a8a20e81ec9e8ae9cf31271e7a1b38140161ec191ac92a0ad0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96532558ab45031bcef634eecabf1e2e3d11f6b424ab0df48495e4250098db12"
    sha256 cellar: :any,                 arm64_ventura:  "96532558ab45031bcef634eecabf1e2e3d11f6b424ab0df48495e4250098db12"
    sha256 cellar: :any,                 arm64_monterey: "96532558ab45031bcef634eecabf1e2e3d11f6b424ab0df48495e4250098db12"
    sha256 cellar: :any,                 sonoma:         "f85cf992e1dbf8f6e52b0d6299a43fb5f2a6bd3f447659ed8e1a7fc484c92d1e"
    sha256 cellar: :any,                 ventura:        "f85cf992e1dbf8f6e52b0d6299a43fb5f2a6bd3f447659ed8e1a7fc484c92d1e"
    sha256 cellar: :any,                 monterey:       "f85cf992e1dbf8f6e52b0d6299a43fb5f2a6bd3f447659ed8e1a7fc484c92d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be72ba98de2f2b5a12a84207bbd71b30699a6150af23a589e4cad0d8f6357901"
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