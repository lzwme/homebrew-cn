class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.27.2.tgz"
  sha256 "dcc20c2ba45db7eb20c49ce23cbe0d487e97baff348ed87acf62f220850ff1c8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d6f6ff6efa82ea9963e5fc9d17998aae95e12a93d0b8c0d7d64bf3e7bd9916d"
    sha256 cellar: :any,                 arm64_sonoma:  "4d6f6ff6efa82ea9963e5fc9d17998aae95e12a93d0b8c0d7d64bf3e7bd9916d"
    sha256 cellar: :any,                 arm64_ventura: "4d6f6ff6efa82ea9963e5fc9d17998aae95e12a93d0b8c0d7d64bf3e7bd9916d"
    sha256 cellar: :any,                 sonoma:        "8505514a464c036e623ffb2d2a5f15603500283a57afaead581326a8ef324945"
    sha256 cellar: :any,                 ventura:       "8505514a464c036e623ffb2d2a5f15603500283a57afaead581326a8ef324945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "693172c617d43f0dbaef958e190fcc5e695ace05e58f59df600a356a8fc9d67e"
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