class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.37.0.tgz"
  sha256 "a218971ff47131ba6fa5a9b383ff18548d592ee7db85a10cd5c33b61cd6a22eb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e31adf9bf9a9100421a3cd516d21d974b2830f30315b04e9ea1fbd33785b920b"
    sha256 cellar: :any,                 arm64_sonoma:  "e31adf9bf9a9100421a3cd516d21d974b2830f30315b04e9ea1fbd33785b920b"
    sha256 cellar: :any,                 arm64_ventura: "e31adf9bf9a9100421a3cd516d21d974b2830f30315b04e9ea1fbd33785b920b"
    sha256 cellar: :any,                 sonoma:        "8b76bdf5bce3abb38baba48c82e2cac4822c9d0994860cc6d5f8fd2740065831"
    sha256 cellar: :any,                 ventura:       "8b76bdf5bce3abb38baba48c82e2cac4822c9d0994860cc6d5f8fd2740065831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d9a761d98b937fbf2cdfe37111dab8714b306aa157e8e9b2f551d500ceff90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c82746a0a8026abced81477a0cae63f34fcd8317eca80799db4e09d75789e90"
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