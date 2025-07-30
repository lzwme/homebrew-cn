class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.46.2.tgz"
  sha256 "6dc9b57afe35cafcd40fa1d11138f37b8b5871b19b5fe29bd0205b20bf1a6b49"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0ad1db1d0a728ddad6f744b705f0d593a5c3bd1112423f957b70427da5c75af"
    sha256 cellar: :any,                 arm64_sonoma:  "f0ad1db1d0a728ddad6f744b705f0d593a5c3bd1112423f957b70427da5c75af"
    sha256 cellar: :any,                 arm64_ventura: "f0ad1db1d0a728ddad6f744b705f0d593a5c3bd1112423f957b70427da5c75af"
    sha256 cellar: :any,                 sonoma:        "51066d36c961f4e443f5855caaf5ac9d874b1160e4cc53bff6548ce9da894eda"
    sha256 cellar: :any,                 ventura:       "51066d36c961f4e443f5855caaf5ac9d874b1160e4cc53bff6548ce9da894eda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79e86080cb86db217cb09dd500b9e18bbd15dabfe8991541a57b47176d3e707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2866300def36f54cf290e2b5b041ee16e7ba65e195a657ae6d895b6eafb47e"
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