class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.40.1.tgz"
  sha256 "cf43dd4dc3d893778661818b3ebd226d9fa27e8945e18f36dbb2b98eeea7f0dc"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b0146860111da5ea400e647a5f7ba4ef0758d59da7c6d79acc391e576a59531"
    sha256 cellar: :any,                 arm64_sonoma:  "2b0146860111da5ea400e647a5f7ba4ef0758d59da7c6d79acc391e576a59531"
    sha256 cellar: :any,                 arm64_ventura: "2b0146860111da5ea400e647a5f7ba4ef0758d59da7c6d79acc391e576a59531"
    sha256 cellar: :any,                 sonoma:        "df887a37784e87a0b81afcb6fb18852c65c3b9b7b43f9d639897705a58454a77"
    sha256 cellar: :any,                 ventura:       "df887a37784e87a0b81afcb6fb18852c65c3b9b7b43f9d639897705a58454a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e592fc29edb53e79896ee72e03e3b378c80388f7fd7732bfb1d1c5829ac90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "728b092b82847a33a69f839fbd69221b4a3aed57f7bbf7b646dc002d0310a53b"
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