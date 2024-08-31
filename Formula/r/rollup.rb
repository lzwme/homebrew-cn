class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.21.2.tgz"
  sha256 "0267d49e19776dcadf1ad0afb0881e0724d4793cf68b756a843ff4532f8808f0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d6810e47adc91ada51588fc8cc9519f0a3a1a7f568078ae685f5a6529631c98"
    sha256 cellar: :any,                 arm64_ventura:  "8d6810e47adc91ada51588fc8cc9519f0a3a1a7f568078ae685f5a6529631c98"
    sha256 cellar: :any,                 arm64_monterey: "8d6810e47adc91ada51588fc8cc9519f0a3a1a7f568078ae685f5a6529631c98"
    sha256 cellar: :any,                 sonoma:         "0eb5f5e8ec29c77574c7acf4d2f9eeefeb83ad637868af05fb9aa31df6af5fe9"
    sha256 cellar: :any,                 ventura:        "0eb5f5e8ec29c77574c7acf4d2f9eeefeb83ad637868af05fb9aa31df6af5fe9"
    sha256 cellar: :any,                 monterey:       "0eb5f5e8ec29c77574c7acf4d2f9eeefeb83ad637868af05fb9aa31df6af5fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228f1dfe6431e457e2956ede9d58e202fe73c91c83bde00410b53b6ddf483d7b"
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