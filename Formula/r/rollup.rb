class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.53.2.tgz"
  sha256 "b45685a81bef2e4b6a33bba4b4f1f921d84fc277d033c82c741a5e653cba2205"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f335e271c000df77ec4e4ea68b2464d5685622d0197f89abd5ea255d162824c"
    sha256 cellar: :any,                 arm64_sequoia: "0ca2e6d5243fe3dd0fbfaa347e1bdb4ba8b8c653ced2c31f1c19a47ea5b60f43"
    sha256 cellar: :any,                 arm64_sonoma:  "0ca2e6d5243fe3dd0fbfaa347e1bdb4ba8b8c653ced2c31f1c19a47ea5b60f43"
    sha256 cellar: :any,                 sonoma:        "864e73607981d51bad13473e2fb17c322af5a70dd67a8599dcf2baaf9afc5715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0873c937f02a7a145f5bb742895c0b214785899cab79fdbe211cdac7f9a33c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cf20fa73f2c8cc60e7ef2fad4868c7ed7c3a36b3e72cfc6075ef44ee2f8b4f"
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