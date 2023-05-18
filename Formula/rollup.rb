require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.22.0.tgz"
  sha256 "570a3edf624fdbd4bd1be5729e4629e7a3a89a1235994aff731ca9a7c875dc02"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50127a71c7dfe0e7fa9dda11285b69549b17014fd74cd848cf08e3ab14d6c6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50127a71c7dfe0e7fa9dda11285b69549b17014fd74cd848cf08e3ab14d6c6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a50127a71c7dfe0e7fa9dda11285b69549b17014fd74cd848cf08e3ab14d6c6c"
    sha256 cellar: :any_skip_relocation, ventura:        "d16e9ef014edfb7a67311f3f3b5aea13e0e2ebbcd9d6d787e89f321b89fa59d2"
    sha256 cellar: :any_skip_relocation, monterey:       "d16e9ef014edfb7a67311f3f3b5aea13e0e2ebbcd9d6d787e89f321b89fa59d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d16e9ef014edfb7a67311f3f3b5aea13e0e2ebbcd9d6d787e89f321b89fa59d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a5b657a334ba0f4208448e075128e7b20b06b4ead6854ebe745066ca9b157f"
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