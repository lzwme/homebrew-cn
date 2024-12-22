class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.29.1.tgz"
  sha256 "653b9922b4d9a4872ad0c6e607e8f17fac4a1a8e7dccba882a4f976a28585f94"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae9c4043ffcb3bbc40b211d6d2fc643585245a3a8ebab8b8a75aff698db6d8f7"
    sha256 cellar: :any,                 arm64_sonoma:  "ae9c4043ffcb3bbc40b211d6d2fc643585245a3a8ebab8b8a75aff698db6d8f7"
    sha256 cellar: :any,                 arm64_ventura: "ae9c4043ffcb3bbc40b211d6d2fc643585245a3a8ebab8b8a75aff698db6d8f7"
    sha256 cellar: :any,                 sonoma:        "ccefd869f741a96a61736d9278cd651921907b2aa0873370ee1105ef71293f8a"
    sha256 cellar: :any,                 ventura:       "ccefd869f741a96a61736d9278cd651921907b2aa0873370ee1105ef71293f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356d327507f286abc0be4df5e008edc3ebb426e96d9eeb0f9ceb2d45c3cc79de"
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