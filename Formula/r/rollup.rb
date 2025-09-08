class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.50.1.tgz"
  sha256 "913170194506de61e78e39ce57d12c66dcbca7585a89c0b0e0d2fd87c3981fef"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3f8ba59471d9e49910fe40fa4f0b8c760c4a77de41ab86ad4eb06d324d48d64"
    sha256 cellar: :any,                 arm64_sonoma:  "e3f8ba59471d9e49910fe40fa4f0b8c760c4a77de41ab86ad4eb06d324d48d64"
    sha256 cellar: :any,                 arm64_ventura: "e3f8ba59471d9e49910fe40fa4f0b8c760c4a77de41ab86ad4eb06d324d48d64"
    sha256 cellar: :any,                 sonoma:        "58889eabd72295e8c1a88f0d53f428caed1e259c259d778ee9b5309bfb1f61a8"
    sha256 cellar: :any,                 ventura:       "58889eabd72295e8c1a88f0d53f428caed1e259c259d778ee9b5309bfb1f61a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40328ba58e84eaa81f6452eb7de2d57c54caf1ddec3a1aac55b66cd2d77ddf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f30636642275930b42bd08e9ee5c853b02e4f4407a824fc2ff463964304e6993"
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