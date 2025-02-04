class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.1.tgz"
  sha256 "4fc5c9b538579026dbdf81f5060da40367f89b62041df8c08daf6308a5f66dc1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3ea6c65881753ff4ed1ac94da9ca4db8c33cd09ed9b6858c217a9f4ceffb5bf"
    sha256 cellar: :any,                 arm64_sonoma:  "c3ea6c65881753ff4ed1ac94da9ca4db8c33cd09ed9b6858c217a9f4ceffb5bf"
    sha256 cellar: :any,                 arm64_ventura: "c3ea6c65881753ff4ed1ac94da9ca4db8c33cd09ed9b6858c217a9f4ceffb5bf"
    sha256 cellar: :any,                 sonoma:        "d9ac68c28781e779d15f10c93e400c80a321d07885c0f7f8944eb07aeb60a09c"
    sha256 cellar: :any,                 ventura:       "d9ac68c28781e779d15f10c93e400c80a321d07885c0f7f8944eb07aeb60a09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076dac5348a61acfa69fe15eca17d6eee445762ef06a7e9f27da6741f25ed3bb"
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