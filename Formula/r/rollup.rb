class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.52.2.tgz"
  sha256 "f9b03ada134e8af395595631cb81e01641576941f7439e5d09abfc16010d00f8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd31f59600af4acaecaa0006c93035b6753b2ebd1a310bb0d6a6243a95542f50"
    sha256 cellar: :any,                 arm64_sequoia: "081f6e00b02797e55b52cdb904350a82eafd4749dd670e3ca70aa2cbba3d1376"
    sha256 cellar: :any,                 arm64_sonoma:  "081f6e00b02797e55b52cdb904350a82eafd4749dd670e3ca70aa2cbba3d1376"
    sha256 cellar: :any,                 sonoma:        "753c660e471e32d222ac7147244fd76cc2b17b4c95548edbf943b1763e252039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7978a285630dd927bb0f493b4c6970e2753ce3c2fd8d84865d350df9cca9c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e266c952b94bd53726f04526f478e2d816dfcff0cb596c5bed19e37e65a135d3"
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