class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.53.1.tgz"
  sha256 "0232a72ab4a5d4ba2ed7803ec185ce361441fbca887c169310957b83c45758a1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9de0b9e7f457b3a5bdf1bd0aaaef540c8aed822c73f58f2fa465b4a92310813"
    sha256 cellar: :any,                 arm64_sequoia: "fb73086aa03208f344f26261dcb2842f530346241b31ff0179718236c7b30527"
    sha256 cellar: :any,                 arm64_sonoma:  "fb73086aa03208f344f26261dcb2842f530346241b31ff0179718236c7b30527"
    sha256 cellar: :any,                 sonoma:        "994d0e77479be3c2406f1980e04dc64495dada949faa6df6514ebcee49026446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8adabf849a40e25e23cc6df40d36f096e22229415ec998fcad4a8d63a8aece24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558d8e5176c09707449ec94326c098780509a2752f8a4296daf1efcad0050e98"
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