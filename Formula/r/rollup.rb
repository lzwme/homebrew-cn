class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.8.tgz"
  sha256 "b8bcf547a41285a1d785d90e3a067141cad78fbf5ff84fd13058266de2ab69f0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b802b877e25eb4071ddc7fcfab3d5eb38f669f3ca5ce0f6d38f3826f45381a8a"
    sha256 cellar: :any,                 arm64_sonoma:  "b802b877e25eb4071ddc7fcfab3d5eb38f669f3ca5ce0f6d38f3826f45381a8a"
    sha256 cellar: :any,                 arm64_ventura: "b802b877e25eb4071ddc7fcfab3d5eb38f669f3ca5ce0f6d38f3826f45381a8a"
    sha256 cellar: :any,                 sonoma:        "8cde134bd9c5b6f352bbc0efda0048c5594d0f5e70aeeb307a5a8e5d1ecda6a4"
    sha256 cellar: :any,                 ventura:       "8cde134bd9c5b6f352bbc0efda0048c5594d0f5e70aeeb307a5a8e5d1ecda6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b96813a8f056c817bcb6cbf65d0470ba93798590289d12fcf750dd83f50e72b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end