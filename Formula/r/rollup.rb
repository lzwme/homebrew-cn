class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.21.3.tgz"
  sha256 "35ee4d11f484648c993ac733e3a7975669970870c14380d2a634d1dd5ece0048"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37236136655bb7bf381481a280a4da63403105b48ab0f5436a2b9e68b4579fb1"
    sha256 cellar: :any,                 arm64_ventura:  "37236136655bb7bf381481a280a4da63403105b48ab0f5436a2b9e68b4579fb1"
    sha256 cellar: :any,                 arm64_monterey: "37236136655bb7bf381481a280a4da63403105b48ab0f5436a2b9e68b4579fb1"
    sha256 cellar: :any,                 sonoma:         "a38ebf47e7b59b8cc2631df8b1d8a8ae43403bf5bf8059d50b3bbdcf389a1684"
    sha256 cellar: :any,                 ventura:        "a38ebf47e7b59b8cc2631df8b1d8a8ae43403bf5bf8059d50b3bbdcf389a1684"
    sha256 cellar: :any,                 monterey:       "a38ebf47e7b59b8cc2631df8b1d8a8ae43403bf5bf8059d50b3bbdcf389a1684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ebe1410d969b5cfabb6fda5983ec6a5e03186494632bb1722fcf982a662af58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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