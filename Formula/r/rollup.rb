class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.24.3.tgz"
  sha256 "3ab53b9e084794eb70472f67be7dfc06af805a8b770cf9811b5df8f83aa82553"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "917fd51b3522efcbf3c38b4ecd288b591ca78df78d836eebba49d43033410d53"
    sha256 cellar: :any,                 arm64_sonoma:  "917fd51b3522efcbf3c38b4ecd288b591ca78df78d836eebba49d43033410d53"
    sha256 cellar: :any,                 arm64_ventura: "917fd51b3522efcbf3c38b4ecd288b591ca78df78d836eebba49d43033410d53"
    sha256 cellar: :any,                 sonoma:        "718b153569775c0f5f3071085ce80ba4260c6478ac9759561b06e485b2fb6122"
    sha256 cellar: :any,                 ventura:       "718b153569775c0f5f3071085ce80ba4260c6478ac9759561b06e485b2fb6122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4671097ff63d60c876b32eba4bf224cc9f21e13bc4aa478d93168573d2398fb3"
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